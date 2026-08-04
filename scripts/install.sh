#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "${script_dir}/.." && pwd -P)"
source_flake_ref="path:${repo_root}"
flake_ref=""
flake_store_path=""
nix_flags=(--extra-experimental-features "nix-command flakes")
efi_vars_dir="/sys/firmware/efi/efivars"
secure_boot_var="${efi_vars_dir}/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c"
install_data_dir="/run/nixbook-install"
target_root="/mnt/nixbook-install"
minimum_disk_bytes=$((128 * 1024 * 1024 * 1024))
minimum_store_free_bytes=$((64 * 1024 * 1024 * 1024))
swap_bytes=$((32 * 1024 * 1024 * 1024))
fuser_bin=""
disko_bin=""
resume=0
layout_started=0
layout_ready=0
target_swap_active=0
disk_operation_started=0
disko_args=()

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh /dev/disk/by-id/<target-disk>
       ./scripts/install.sh --resume /dev/disk/by-id/<target-disk>

Without --resume, the target disk is completely erased. Use
`ls -l /dev/disk/by-id/` and `lsblk` to identify it. Partition paths such as
/dev/nvme0n1p1 are rejected.

Use --resume only after this installer already formatted the same disk. Resume
opens and mounts the existing layout; it never formats or destroys partitions.
EOF
}

require_commands() {
  local tool

  for tool in awk blkid blockdev cat chmod cp cryptsetup df fallocate find findmnt grep install lsblk mkdir mkswap nix nix-store od readlink rm rmdir stat swapoff swapon sync tr umount; do
    command -v "${tool}" >/dev/null 2>&1 || die "required command '${tool}' was not found."
  done
}

check_efi_state() {
  local efi_mount_info efi_fs_type efi_options secure_boot_state bootctl_status

  [[ -d ${efi_vars_dir} ]] ||
    die "the installer was not booted in UEFI mode. Reboot the installation media in UEFI mode."

  efi_mount_info="$(findmnt -nro FSTYPE,OPTIONS -T "${efi_vars_dir}")" ||
    die "cannot inspect the EFI variable filesystem."
  efi_fs_type="${efi_mount_info%% *}"
  efi_options="${efi_mount_info#* }"

  [[ ${efi_fs_type} == "efivarfs" ]] || die "efivarfs is not mounted at ${efi_vars_dir}."
  [[ ,${efi_options}, == *,rw,* ]] ||
    die "efivarfs is read-only; systemd-boot cannot create an EFI boot entry safely."

  if [[ -e ${secure_boot_var} ]]; then
    [[ -r ${secure_boot_var} ]] || die "the Secure Boot EFI variable is not readable."
    secure_boot_state="$({ od -An -t u1 -j 4 -N 1 -- "${secure_boot_var}" || exit 1; } | tr -d '[:space:]')" ||
      die "cannot read the Secure Boot state."

    case "${secure_boot_state}" in
      0) ;;
      1) die "Secure Boot is enabled, but this configuration does not sign its boot files. Disable Secure Boot first." ;;
      *) die "the firmware returned an unknown Secure Boot state: ${secure_boot_state:-empty}." ;;
    esac
  else
    command -v bootctl >/dev/null 2>&1 ||
      die "the Secure Boot EFI variable is missing and bootctl is unavailable to verify the state."
    bootctl_status="$(SYSTEMD_COLORS=0 LC_ALL=C bootctl status --no-pager 2>/dev/null || true)"
    if ! grep -Eq 'Secure Boot:[[:space:]]+(disabled|not supported)' <<<"${bootctl_status}"; then
      die "the Secure Boot state could not be verified."
    fi
  fi
}

resolve_target_disk() {
  [[ ${target_disk} =~ ^/dev/disk/by-id/[^/]+$ ]] ||
    die "use one direct /dev/disk/by-id/... path without '..' or additional path components."
  [[ -L ${target_disk} ]] || die "${target_disk} is not a /dev/disk/by-id symlink."

  resolved_target="$(readlink -e -- "${target_disk}")" || die "cannot resolve ${target_disk}."
  [[ -b ${resolved_target} ]] || die "${target_disk} does not resolve to a block device."
  [[ "$(lsblk -dnro TYPE -- "${resolved_target}")" == "disk" ]] ||
    die "${target_disk} does not resolve to a whole disk."
}

target_identity() {
  local resolved details serial wwn

  resolved="$(readlink -e -- "${target_disk}")" || return 1
  serial="$(lsblk -dnro SERIAL -- "${resolved}")" || return 1
  wwn="$(lsblk -dnro WWN -- "${resolved}")" || return 1
  [[ -n ${serial//[[:space:]]/} || -n ${wwn//[[:space:]]/} ]] || return 1
  details="$(lsblk -dnrbo MAJ:MIN,SIZE,SERIAL,WWN -- "${resolved}")" || return 1
  printf '%s|%s\n' "${resolved}" "${details}"
}

parent_disk_of() {
  lsblk -snrpo NAME,TYPE -- "$1" | awk '$2 == "disk" { print $1; exit }'
}

parent_partition_of() {
  lsblk -snrpo NAME,TYPE -- "$1" | awk '$2 == "part" { print $1; exit }'
}

show_target_tree() {
  lsblk -o NAME,PATH,SIZE,MODEL,SERIAL,TYPE,FSTYPE,MOUNTPOINTS -- "${resolved_target}" >&2
}

check_fuser_operational() {
  local probe_fd

  exec {probe_fd}<"${script_dir}/install.sh" || die "cannot open the fuser test file."
  if ! "${fuser_bin}" --silent "${script_dir}/install.sh"; then
    exec {probe_fd}<&-
    die "fuser cannot inspect open files through /proc."
  fi
  exec {probe_fd}<&-
}

check_target_unused() {
  local mount_output type_output filesystem_output swap_output device_output
  local mountpoints device_type filesystem_type swap_path swap_source swap_parent
  local device_path fuser_output fuser_status

  mount_output="$(lsblk -nrpo MOUNTPOINTS -- "${resolved_target}")" ||
    die "cannot inspect target-disk mount points."
  while IFS= read -r mountpoints; do
    if [[ -n ${mountpoints//[[:space:]]/} ]]; then
      show_target_tree
      die "the target disk or one of its child devices is mounted or used as swap."
    fi
  done <<<"${mount_output}"

  type_output="$(lsblk -nrpo TYPE -- "${resolved_target}")" ||
    die "cannot inspect target-disk mappings."
  while IFS= read -r device_type; do
    case "${device_type}" in
      disk | part) ;;
      *)
        show_target_tree
        die "the target disk has an active ${device_type} mapping. Close it before installing."
        ;;
    esac
  done <<<"${type_output}"

  filesystem_output="$(lsblk -nrpo FSTYPE -- "${resolved_target}")" ||
    die "cannot inspect target-disk filesystem signatures."
  while IFS= read -r filesystem_type; do
    case "${filesystem_type}" in
      zfs_member)
        die "the target contains a ZFS pool member. Export and disconnect the pool, then remove the ZFS signature explicitly before installing."
        ;;
      LVM2_member)
        die "the target contains an LVM physical volume. Remove it from its volume group and clear the LVM signature explicitly before installing."
        ;;
      linux_raid_member)
        die "the target contains a Linux software-RAID member. Remove it from the array and clear the RAID signature explicitly before installing."
        ;;
    esac
  done <<<"${filesystem_output}"

  if [[ -n ${fuser_bin} ]]; then
    check_fuser_operational
    device_output="$(lsblk -nrpo NAME -- "${resolved_target}")" ||
      die "cannot list target-disk device nodes."
    while IFS= read -r device_path; do
      [[ -n ${device_path} ]] || continue
      [[ -b ${device_path} ]] || die "${device_path} is no longer a block device."
      if fuser_output="$("${fuser_bin}" --silent "${device_path}" 2>&1)"; then
        show_target_tree
        die "a process is directly using ${device_path}. Stop that process before installing."
      else
        fuser_status=$?
        if ((fuser_status != 1)) || [[ -n ${fuser_output} ]]; then
          die "fuser could not safely inspect ${device_path}: ${fuser_output:-unknown error}."
        fi
      fi
    done <<<"${device_output}"
  fi

  swap_output="$(swapon --show=NAME --noheadings --raw)" || die "cannot inspect active swap devices."
  while IFS= read -r swap_path; do
    [[ -n ${swap_path} ]] || continue
    if [[ -b ${swap_path} ]]; then
      swap_source="$(readlink -e -- "${swap_path}" || true)"
    else
      swap_source="$(findmnt -nro SOURCE -T "${swap_path}" 2>/dev/null || true)"
    fi
    [[ -n ${swap_source} && -b ${swap_source} ]] || continue
    swap_parent="$(parent_disk_of "${swap_source}")"
    if [[ -n ${swap_parent} ]] && [[ "$(readlink -e -- "${swap_parent}")" == "${resolved_target}" ]]; then
      die "active swap ${swap_path} is backed by the target disk."
    fi
  done <<<"${swap_output}"
}

check_reserved_names() {
  local label partitions partition parent blkid_status

  [[ ! -e /dev/mapper/nixbook-crypted ]] ||
    die "/dev/mapper/nixbook-crypted already exists. Close the old mapping before installing."

  for label in nixbook-ESP nixbook-LUKS; do
    if partitions="$(blkid -c /dev/null -t "PARTLABEL=${label}" -o device 2>/dev/null)"; then
      :
    else
      blkid_status=$?
      if ((blkid_status == 2)); then
        partitions=""
      else
        die "blkid failed while checking partition label ${label}."
      fi
    fi

    while IFS= read -r partition; do
      [[ -n ${partition} ]] || continue
      parent="$(parent_disk_of "${partition}")"
      if [[ -z ${parent} ]] || [[ "$(readlink -e -- "${parent}")" != "${resolved_target}" ]]; then
        die "partition label ${label} is already used by another connected disk. Disconnect that disk first."
      fi
    done <<<"${partitions}"
  done
}

partition_for_label() {
  local label="$1"
  local partition parent
  local count=0
  local result=""

  while IFS= read -r partition; do
    [[ -n ${partition} ]] || continue
    parent="$(parent_disk_of "${partition}")"
    if [[ -n ${parent} ]] && [[ "$(readlink -e -- "${parent}")" == "${resolved_target}" ]]; then
      result="${partition}"
      count=$((count + 1))
    fi
  done < <(blkid -c /dev/null -t "PARTLABEL=${label}" -o device 2>/dev/null || true)

  ((count == 1)) || die "resume requires exactly one ${label} partition on ${target_disk}."
  printf '%s\n' "${result}"
}

check_resume_layout() {
  local esp_partition luks_partition partition_count

  [[ "$(lsblk -dnro PTTYPE -- "${resolved_target}")" == "gpt" ]] ||
    die "resume requires the GPT layout created by this installer."

  partition_count="$(lsblk -nrpo TYPE -- "${resolved_target}" | awk '$1 == "part" { count++ } END { print count + 0 }')"
  [[ ${partition_count} == "2" ]] ||
    die "resume requires exactly the two partitions created by this installer."

  esp_partition="$(partition_for_label nixbook-ESP)"
  luks_partition="$(partition_for_label nixbook-LUKS)"
  [[ "$(blkid -c /dev/null -s TYPE -o value -- "${esp_partition}")" == "vfat" ]] ||
    die "the nixbook-ESP partition is not a vfat filesystem."
  [[ "$(blkid -c /dev/null -s TYPE -o value -- "${luks_partition}")" == "crypto_LUKS" ]] ||
    die "the nixbook-LUKS partition is not a LUKS container."
}

check_target_root_unused() {
  local mount_target first_entry

  while IFS= read -r mount_target; do
    if [[ ${mount_target} == "${target_root}" || ${mount_target} == "${target_root}/"* ]]; then
      die "${mount_target} is already mounted below ${target_root}; unmount it before running the installer."
    fi
  done < <(findmnt -rn -o TARGET)

  if [[ -e ${target_root} || -L ${target_root} ]]; then
    [[ ! -L ${target_root} ]] || die "${target_root} must not be a symbolic link."
    [[ -d ${target_root} ]] || die "${target_root} exists and is not a directory."
    first_entry="$(find "${target_root}" -mindepth 1 -maxdepth 1 -print -quit)"
    [[ -z ${first_entry} ]] || die "${target_root} is not empty. Remove its contents only after inspecting them."
  fi
}

check_minimum_capacity() {
  local disk_bytes

  disk_bytes="$(blockdev --getsize64 "${resolved_target}")"
  ((disk_bytes >= minimum_disk_bytes)) ||
    die "the target disk is $((disk_bytes / 1024 / 1024 / 1024)) GiB; at least 128 GiB is required."
}

verify_target_unchanged() {
  local current_identity

  resolve_target_disk
  current_identity="$(target_identity)" || die "cannot read the target disk identity."
  [[ ${current_identity} == "${initial_target_identity}" ]] ||
    die "the target disk identity changed during preflight. Restart the installer and identify the disk again."
  check_target_unused
  check_reserved_names
  check_minimum_capacity
  if ((resume)); then
    check_resume_layout
  fi
  check_target_root_unused
}

freeze_flake() {
  flake_store_path="$(
    NIXBOOK_FLAKE_SOURCE="${repo_root}" \
      nix "${nix_flags[@]}" eval --raw --impure --expr \
      '(builtins.getFlake ("path:" + builtins.getEnv "NIXBOOK_FLAKE_SOURCE")).outPath'
  )" || die "cannot create an immutable snapshot of ${source_flake_ref}."
  [[ ${flake_store_path} == /nix/store/* && -d ${flake_store_path} ]] ||
    die "Nix returned an invalid flake store path."

  nix-store \
    --add-root "${install_data_dir}/flake-root" \
    --indirect \
    --realise "${flake_store_path}" >/dev/null ||
    die "cannot protect the flake snapshot from garbage collection."
  flake_ref="path:${flake_store_path}"
}

set_disko_args() {
  disko_args=(
    --flake "${flake_ref}#nixbook"
    --argstr device "${target_disk}"
    --root-mountpoint "${target_root}"
  )
}

target_root_has_mounts() {
  findmnt -rn -o TARGET | awk -v root="${target_root}" '
    $0 == root || index($0, root "/") == 1 { found = 1 }
    END { exit !found }
  '
}

cleanup_target() {
  local cleanup_status=0

  if (( !disk_operation_started && !layout_started && !target_swap_active )); then
    return 0
  fi

  set +e
  if ((target_swap_active)); then
    if ! swapoff -- "${target_root}/swap/swapfile"; then
      printf 'Error: swapoff failed; the encrypted target remains mounted for safety.\n' >&2
      set -e
      return 1
    fi
    target_swap_active=0
  fi

  sync || cleanup_status=1
  if ((layout_started)) && [[ -x ${disko_bin} ]]; then
    DISKO_SKIP_SWAP=1 "${disko_bin}" \
      --mode unmount \
      "${disko_args[@]}" || cleanup_status=1
    layout_started=0
  fi

  if target_root_has_mounts; then
    umount -R -- "${target_root}" || cleanup_status=1
  fi
  if [[ -e /dev/mapper/nixbook-crypted ]]; then
    cryptsetup close nixbook-crypted || cleanup_status=1
  fi
  rmdir -- "${target_root}" 2>/dev/null || true
  set -e

  return "${cleanup_status}"
}

cleanup_install_data() {
  if [[ ${install_data_dir} == "/run/nixbook-install" && -d ${install_data_dir} ]]; then
    rm -rf -- "${install_data_dir}"
  fi
}

cleanup() {
  local status=$?

  trap - EXIT
  if ! cleanup_target; then
    printf 'Error: the target could not be fully unmounted. Inspect it before rebooting.\n' >&2
    status=1
  fi
  cleanup_install_data

  if ((status != 0 && disk_operation_started)); then
    printf '\nThe installation failed after target-disk operations started.\n' >&2
    if ((layout_ready || resume)); then
      printf 'Do not run the formatting command again. After fixing the cause, retry with:\n\n' >&2
      printf '  %s --resume %s\n\n' "${script_dir}/install.sh" "${target_disk}" >&2
    else
      printf 'Disko did not complete, so the disk layout can be incomplete. Inspect the disk before another attempt.\n' >&2
    fi
  fi
  exit "${status}"
}

prepare_install_data() {
  [[ ! -e ${install_data_dir} ]] ||
    die "${install_data_dir} already exists from another installer process. Remove it only after confirming no installer is running."
  mkdir -m 0700 -- "${install_data_dir}"
  trap cleanup EXIT
  mkdir -m 0700 -- "${install_data_dir}/passwordFiles"
}

validate_install_data() {
  local path mode

  for path in \
    "${install_data_dir}/luks-password" \
    "${install_data_dir}/passwordFiles/root" \
    "${install_data_dir}/passwordFiles/chen" \
    "${install_data_dir}/machine-id"; do
    [[ -s ${path} ]] || die "required installation data ${path} is missing or empty."
  done

  grep -Eq '^[$]y[$]' "${install_data_dir}/passwordFiles/root" || die "the root password hash is not yescrypt."
  grep -Eq '^[$]y[$]' "${install_data_dir}/passwordFiles/chen" || die "the chen password hash is not yescrypt."
  grep -Eq '^[0-9a-f]{32}$' "${install_data_dir}/machine-id" || die "the generated machine-id is invalid."

  for path in \
    "${install_data_dir}/luks-password" \
    "${install_data_dir}/passwordFiles/root" \
    "${install_data_dir}/passwordFiles/chen"; do
    mode="$(stat -c '%a' -- "${path}")" || die "cannot inspect permissions for ${path}."
    [[ ${mode} == "600" ]] || die "${path} must have mode 0600, not ${mode}."
  done
}

exact_mount_info() {
  local path="$1"

  findmnt -nr -o SOURCE,FSTYPE,FSROOT -M "${path}" ||
    die "${path} is not an exact mount point."
}

verify_bind_mount() {
  local mount_path="$1"
  local backing_path="$2"
  local expected_root="$3"
  local source filesystem_type filesystem_root

  read -r source filesystem_type filesystem_root < <(exact_mount_info "${mount_path}")
  [[ ${filesystem_type} == "ext4" ]] || die "${mount_path} is not backed by ext4."
  [[ ${filesystem_root} == "${expected_root}" ]] ||
    die "${mount_path} has filesystem root ${filesystem_root}, expected ${expected_root}."
  [[ "$(stat -c '%d:%i' -- "${mount_path}")" == "$(stat -c '%d:%i' -- "${backing_path}")" ]] ||
    die "${mount_path} is not a bind mount of ${backing_path}."
}

verify_persistent_directory() {
  local relative_path="$1"
  local path="${target_root}/persist/${relative_path}"

  [[ -d ${path} && ! -L ${path} ]] ||
    die "${path} is not a real directory on the persistent filesystem."
  [[ "$(readlink -e -- "${path}")" == "${path}" ]] ||
    die "${path} contains a symbolic-link component."
  [[ "$(stat -c '%d' -- "${path}")" == "$(stat -c '%d' -- "${target_root}/persist")" ]] ||
    die "${path} is not on the persistent filesystem."
}

verify_mount_topology() {
  local source filesystem_type filesystem_root
  local persist_source mapper_source mapper_parent mapper_partition
  local boot_source boot_parent

  read -r source filesystem_type filesystem_root < <(exact_mount_info "${target_root}")
  [[ ${source} == "tmpfs" && ${filesystem_type} == "tmpfs" && ${filesystem_root} == "/" ]] ||
    die "${target_root} is not the expected tmpfs root."

  read -r persist_source filesystem_type filesystem_root < <(exact_mount_info "${target_root}/persist")
  [[ ${filesystem_type} == "ext4" && ${filesystem_root} == "/" ]] ||
    die "${target_root}/persist is not the expected ext4 root."
  mapper_source="$(readlink -e -- /dev/mapper/nixbook-crypted)" ||
    die "the nixbook-crypted mapper is missing."
  [[ "$(readlink -e -- "${persist_source}")" == "${mapper_source}" ]] ||
    die "${target_root}/persist is not mounted from nixbook-crypted."
  mapper_parent="$(parent_disk_of /dev/mapper/nixbook-crypted)"
  [[ -n ${mapper_parent} && "$(readlink -e -- "${mapper_parent}")" == "${resolved_target}" ]] ||
    die "nixbook-crypted is not backed by the confirmed target disk."
  mapper_partition="$(parent_partition_of /dev/mapper/nixbook-crypted)"
  [[ -n ${mapper_partition} ]] || die "cannot find the partition below nixbook-crypted."
  [[ "$(blkid -c /dev/null -s PARTLABEL -o value -- "${mapper_partition}")" == "nixbook-LUKS" ]] ||
    die "nixbook-crypted is not backed by the nixbook-LUKS partition."

  read -r boot_source filesystem_type filesystem_root < <(exact_mount_info "${target_root}/boot")
  [[ ${filesystem_type} == "vfat" && ${filesystem_root} == "/" ]] ||
    die "${target_root}/boot is not the expected vfat ESP."
  boot_parent="$(parent_disk_of "${boot_source}")"
  [[ -n ${boot_parent} && "$(readlink -e -- "${boot_parent}")" == "${resolved_target}" ]] ||
    die "${target_root}/boot is not on the confirmed target disk."
  [[ "$(blkid -c /dev/null -s PARTLABEL -o value -- "${boot_source}")" == "nixbook-ESP" ]] ||
    die "${target_root}/boot is not the nixbook-ESP partition."

  verify_bind_mount "${target_root}/nix" "${target_root}/persist/nix" "/nix"
  verify_bind_mount "${target_root}/var/log" "${target_root}/persist/var/log" "/var/log"
  verify_bind_mount "${target_root}/tmp" "${target_root}/persist/tmp" "/tmp"
  verify_bind_mount "${target_root}/swap" "${target_root}/persist/swap" "/swap"

  verify_persistent_directory nix
  verify_persistent_directory etc
  verify_persistent_directory var
  verify_persistent_directory var/log
  verify_persistent_directory tmp
  verify_persistent_directory swap
  verify_persistent_directory passwordFiles

  [[ "$(stat -c '%d' -- "${target_root}")" != "$(stat -c '%d' -- "${target_root}/nix")" ]] ||
    die "the target Nix store is still on the tmpfs root."
}

copy_install_data() {
  local target_config_dir="${target_root}/persist/etc/nixbook"
  local existing_machine_id="${target_root}/persist/etc/machine-id"
  local path

  for path in \
    "${target_root}/persist/passwordFiles/root" \
    "${target_root}/persist/passwordFiles/chen" \
    "${existing_machine_id}" \
    "${target_config_dir}"; do
    [[ ! -L ${path} ]] || die "refusing to replace symbolic link ${path}."
  done

  install -d -m 0700 -- "${target_root}/persist/passwordFiles"
  install -m 0600 -- \
    "${install_data_dir}/passwordFiles/root" \
    "${target_root}/persist/passwordFiles/root"
  install -m 0600 -- \
    "${install_data_dir}/passwordFiles/chen" \
    "${target_root}/persist/passwordFiles/chen"
  install -d -m 0755 -- "${target_root}/persist/etc"
  if ((resume)) && [[ -f ${existing_machine_id} ]] && grep -Eq '^[0-9a-f]{32}$' "${existing_machine_id}"; then
    printf 'Reusing the machine ID from the interrupted installation.\n'
  else
    install -m 0444 -- "${install_data_dir}/machine-id" "${existing_machine_id}"
  fi

  [[ ${target_config_dir} == "${target_root}/persist/etc/nixbook" ]] ||
    die "refusing to replace an unexpected configuration path."
  rm -rf -- "${target_config_dir}"
  install -d -m 0755 -- "${target_config_dir}"
  cp -a -- "${flake_store_path}/." "${target_config_dir}/"
}

prepare_target_swap() {
  local swap_file="${target_root}/swap/swapfile"

  [[ ! -L ${swap_file} ]] || die "refusing to use symbolic link ${swap_file}."
  if [[ -e ${swap_file} && ! -f ${swap_file} ]]; then
    die "${swap_file} exists but is not a regular file."
  fi
  fallocate -l "${swap_bytes}" -- "${swap_file}" ||
    die "cannot allocate the 32 GiB target swap file."
  chmod 0600 -- "${swap_file}"
  mkswap "${swap_file}" >/dev/null || die "cannot initialize the target swap file."
  swapon -- "${swap_file}" || die "cannot activate the target swap file."
  target_swap_active=1
}

check_target_store_space() {
  local available_bytes

  if ((resume)); then
    return
  fi
  available_bytes="$(df -B1 --output=avail "${target_root}/nix" | awk 'NR == 2 { print $1 }')"
  [[ ${available_bytes} =~ ^[0-9]+$ ]] || die "cannot calculate free space in the target Nix store."
  ((available_bytes >= minimum_store_free_bytes)) ||
    die "the target Nix store has less than 64 GiB free after creating swap."
}

run_nixos_install() {
  local target_config_dir="${target_root}/persist/etc/nixbook"
  local target_tmp_dir="${target_root}/tmp/nixos-install"

  install -d -m 0700 -- "${target_tmp_dir}"
  printf 'Building the complete NixOS system directly in the encrypted target store...\n'
  TMPDIR="${target_tmp_dir}" \
    "${nixos_install_tools_path}/bin/nixos-install" \
    --root "${target_root}" \
    --flake "path:${target_config_dir}#nixbook" \
    --no-channel-copy \
    --no-root-password \
    --no-write-lock-file
}

verify_installed_system() {
  local boot_entry candidate generation_link generation_path profile_path store_path

  profile_path="${target_root}/nix/var/nix/profiles/system"
  [[ -L ${profile_path} ]] ||
    die "nixos-install did not create the target system profile."
  generation_link="$(readlink -- "${profile_path}")"
  if [[ ${generation_link} =~ ^system-[0-9]+-link$ ]]; then
    generation_path="${target_root}/nix/var/nix/profiles/${generation_link}"
    [[ -L ${generation_path} ]] || die "the target system generation link is missing."
    store_path="$(readlink -- "${generation_path}")"
  elif [[ ${generation_link} =~ ^/nix/var/nix/profiles/system-[0-9]+-link$ ]]; then
    generation_path="${target_root}${generation_link}"
    [[ -L ${generation_path} ]] || die "the target system generation link is missing."
    store_path="$(readlink -- "${generation_path}")"
  else
    store_path="${generation_link}"
  fi
  [[ ${store_path} =~ ^/nix/store/[a-z0-9]{32}- ]] ||
    die "the target system profile does not point to a Nix store path."
  [[ -x ${target_root}${store_path}/bin/switch-to-configuration ]] ||
    die "the target system profile does not exist in the target Nix store."
  [[ -f ${target_root}/boot/loader/loader.conf ]] ||
    die "systemd-boot did not create loader.conf on the target ESP."
  boot_entry=""
  while IFS= read -r candidate; do
    if grep -Fq "init=${store_path}/init" "${candidate}"; then
      boot_entry="${candidate}"
      break
    fi
  done < <(find "${target_root}/boot/loader/entries" -maxdepth 1 -type f -name '*.conf' -print 2>/dev/null || true)
  [[ -n ${boot_entry} ]] ||
    die "systemd-boot did not create a boot entry for the installed target generation."
  grep -Eq '^[$]y[$]' "${target_root}/persist/passwordFiles/root" ||
    die "the installed root password hash is invalid."
  grep -Eq '^[$]y[$]' "${target_root}/persist/passwordFiles/chen" ||
    die "the installed chen password hash is invalid."
  grep -Eq '^[0-9a-f]{32}$' "${target_root}/persist/etc/machine-id" ||
    die "the installed machine-id is invalid."
  [[ -f ${target_root}/persist/etc/nixbook/flake.lock ]] ||
    die "the immutable configuration copy is missing from the target."
}

read_hash() {
  local account="$1"
  local destination="$2"
  local password password_confirm

  while true; do
    printf 'New password for %s: ' "${account}" >/dev/tty
    read -r -s password </dev/tty
    printf '\nRepeat password for %s: ' "${account}" >/dev/tty
    read -r -s password_confirm </dev/tty
    printf '\n' >/dev/tty

    if [[ -z ${password} ]]; then
      printf 'The password cannot be empty.\n' >&2
    elif [[ ${password} != "${password_confirm}" ]]; then
      printf 'Passwords did not match. Try again.\n' >&2
    else
      printf '%s' "${password}" \
        | "${mkpasswd_path}/bin/mkpasswd" -m yescrypt -s >"${destination}"
      chmod 0600 "${destination}"
      unset password password_confirm
      return
    fi
  done
}

read_luks_password() {
  local adjective password password_confirm

  if ((resume)); then
    adjective="Existing"
  else
    adjective="New"
  fi

  while true; do
    printf '%s LUKS disk-encryption password: ' "${adjective}" >/dev/tty
    read -r -s password </dev/tty
    printf '\nRepeat the LUKS disk-encryption password: ' >/dev/tty
    read -r -s password_confirm </dev/tty
    printf '\n' >/dev/tty

    if [[ -z ${password} ]]; then
      printf 'The LUKS password cannot be empty.\n' >&2
    elif [[ ${password} != "${password_confirm}" ]]; then
      printf 'LUKS passwords did not match. Try again.\n' >&2
    else
      printf '%s' "${password}" >"${install_data_dir}/luks-password"
      chmod 0600 "${install_data_dir}/luks-password"
      unset password password_confirm
      return
    fi
  done
}

original_args=("$@")
case "$#" in
  1)
    target_disk="$1"
    ;;
  2)
    [[ $1 == "--resume" ]] || {
      usage >&2
      exit 2
    }
    resume=1
    target_disk="$2"
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if [[ ${EUID} -ne 0 ]]; then
  exec sudo -- "${script_dir}/install.sh" "${original_args[@]}"
fi

require_commands
check_efi_state
resolve_target_disk
check_target_unused
check_reserved_names
check_minimum_capacity
if ((resume)); then
  check_resume_layout
fi
check_target_root_unused
initial_target_identity="$(target_identity)" ||
  die "the target disk must expose a stable SERIAL or WWN so its identity can be rechecked safely."

prepare_install_data
freeze_flake
set_disko_args

printf 'Building the pinned installation tools before asking for secrets...\n'
disko_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#disko" \
    --out-link "${install_data_dir}/disko" \
    --print-out-paths
)"
disko_bin="${disko_path}/bin/disko"
mkpasswd_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#mkpasswd^out" \
    --out-link "${install_data_dir}/mkpasswd" \
    --print-out-paths
)"
nixos_install_tools_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#nixos-install-tools" \
    --out-link "${install_data_dir}/nixos-install-tools" \
    --print-out-paths
)"
psmisc_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#psmisc" \
    --out-link "${install_data_dir}/psmisc" \
    --print-out-paths
)"
fuser_bin="${psmisc_path}/bin/fuser"
[[ -x ${disko_bin} ]] || die "the pinned Disko executable is missing."
[[ -x ${mkpasswd_path}/bin/mkpasswd ]] || die "the pinned mkpasswd executable is missing."
[[ -x ${nixos_install_tools_path}/bin/nixos-install ]] ||
  die "the pinned nixos-install executable is missing."
[[ -x ${fuser_bin} ]] || die "the pinned fuser executable is missing."

verify_target_unchanged

printf 'Prebuilding the exact Disko mount and cleanup scripts...\n'
if ((resume)); then
  "${disko_bin}" --mode mount "${disko_args[@]}" --dry-run
else
  "${disko_bin}" --mode destroy,format,mount "${disko_args[@]}" --yes-wipe-all-disks --dry-run
fi
"${disko_bin}" --mode unmount "${disko_args[@]}" --dry-run

printf 'Checking the pinned Haskell extensions, including the replacement for the old failed URL...\n'
nix "${nix_flags[@]}" build \
  "${flake_ref}#vscode-haskell" \
  --out-link "${install_data_dir}/vscode-haskell" >/dev/null
nix "${nix_flags[@]}" build \
  "${flake_ref}#vscode-language-haskell" \
  --out-link "${install_data_dir}/vscode-language-haskell" >/dev/null

printf 'Evaluating the full NixOS configuration without downloading its package closure...\n'
nix "${nix_flags[@]}" eval --raw \
  "${flake_ref}#nixosConfigurations.nixbook.config.system.build.toplevel.drvPath" >/dev/null
full_build_plan_log="${install_data_dir}/full-build-plan.log"
if ! nix "${nix_flags[@]}" build \
  "${flake_ref}#nixosConfigurations.nixbook.config.system.build.toplevel" \
  --dry-run >"${full_build_plan_log}" 2>&1; then
  cat -- "${full_build_plan_log}" >&2
  die "cannot calculate the full-system build plan."
fi
grep -E '^(these [0-9]+ derivations will be built:|these [0-9]+ paths will be fetched .*)$' \
  "${full_build_plan_log}" || true
rm -f -- "${full_build_plan_log}"

original_umask="$(umask)"
umask 077
read_hash root "${install_data_dir}/passwordFiles/root"
read_hash chen "${install_data_dir}/passwordFiles/chen"
read_luks_password

if command -v systemd-id128 >/dev/null 2>&1; then
  systemd-id128 new >"${install_data_dir}/machine-id"
else
  tr -d '-' </proc/sys/kernel/random/uuid >"${install_data_dir}/machine-id"
fi
chmod 0444 "${install_data_dir}/machine-id"
umask "${original_umask}"
validate_install_data

check_efi_state
verify_target_unchanged

if ((resume)); then
  printf '\nAll preflight checks passed. No partition will be formatted.\n'
  printf 'The existing encrypted target will be mounted and its partial Nix store reused.\n\n'
  show_target_tree
  printf '\nType "RESUME %s" to continue: ' "${target_disk}"
  read -r confirmation </dev/tty
  [[ ${confirmation} == "RESUME ${target_disk}" ]] ||
    die "confirmation did not match. Nothing was changed."
else
  printf '\nAll preflight checks passed. The following disk will be permanently erased:\n\n'
  show_target_tree
  printf '\nThe full system is built after erasure, directly on the target disk.\n'
  printf 'A later network, download, build, or space failure can leave it unbootable.\n'
  printf '\nType "ERASE %s" to continue: ' "${target_disk}"
  read -r confirmation </dev/tty
  [[ ${confirmation} == "ERASE ${target_disk}" ]] ||
    die "confirmation did not match. Nothing was changed."
fi

check_efi_state
verify_target_unchanged
validate_install_data
set_disko_args
mkdir -p -- "${target_root}"
[[ "$(readlink -e -- "${target_root}")" == "${target_root}" ]] ||
  die "${target_root} did not resolve to the expected mount-point directory."
disk_operation_started=1
layout_started=1
if ((resume)); then
  DISKO_SKIP_SWAP=1 "${disko_bin}" --mode mount "${disko_args[@]}"
else
  DISKO_SKIP_SWAP=1 "${disko_bin}" \
    --mode destroy,format,mount \
    "${disko_args[@]}" \
    --yes-wipe-all-disks
fi
layout_ready=1

verify_mount_topology
copy_install_data
prepare_target_swap
check_target_store_space
run_nixos_install
verify_installed_system
sync

cleanup_target || die "the installation completed, but the target could not be safely unmounted."
cleanup_install_data
trap - EXIT
disk_operation_started=0

printf '\nInstallation finished. Remove the installation media and reboot into the complete system.\n'
