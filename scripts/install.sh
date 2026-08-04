#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "${script_dir}/.." && pwd -P)"
source_flake_ref="path:${repo_root}"
flake_ref=""
nix_flags=(--extra-experimental-features "nix-command flakes")
efi_vars_dir="/sys/firmware/efi/efivars"
secure_boot_var="${efi_vars_dir}/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c"
install_data_dir="/run/nixbook-install"
minimum_disk_bytes=$((80 * 1024 * 1024 * 1024))
swap_bytes=$((32 * 1024 * 1024 * 1024))
esp_bytes=$((1 * 1024 * 1024 * 1024))
free_margin_bytes=$((16 * 1024 * 1024 * 1024))
fuser_bin=""

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh /dev/disk/by-id/<target-disk>

The target disk is completely erased. Use `ls -l /dev/disk/by-id/` and
`lsblk` to identify it. Partition paths such as /dev/nvme0n1p1 are rejected.
EOF
}

require_commands() {
  local tool

  for tool in awk blkid blockdev chmod findmnt grep lsblk mkdir nix nix-store od readlink rm stat swapon tr; do
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

check_minimum_capacity() {
  local disk_bytes

  disk_bytes="$(blockdev --getsize64 "${resolved_target}")"
  ((disk_bytes >= minimum_disk_bytes)) ||
    die "the target disk is $((disk_bytes / 1024 / 1024 / 1024)) GiB; at least 80 GiB is required."
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
}

freeze_flake() {
  local flake_store_path

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
    --mode format
    --disk main "${target_disk}"
    --write-efi-boot-entries
  )
}

cleanup() {
  if [[ ${install_data_dir} == "/run/nixbook-install" && -d ${install_data_dir} ]]; then
    rm -rf -- "${install_data_dir}"
  fi
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

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

target_disk="$1"

if [[ ${EUID} -ne 0 ]]; then
  exec sudo -- "${script_dir}/install.sh" "${target_disk}"
fi

require_commands
check_efi_state
resolve_target_disk
check_target_unused
check_reserved_names
check_minimum_capacity
initial_target_identity="$(target_identity)" ||
  die "the target disk must expose a stable SERIAL or WWN so its identity can be rechecked safely."

prepare_install_data
freeze_flake
set_disko_args

printf 'Building the exact NixOS system and Disko scripts before asking for secrets...\n'
disko_install_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#disko-install" \
    --out-link "${install_data_dir}/disko-install" \
    --print-out-paths
)"
mkpasswd_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#mkpasswd" \
    --out-link "${install_data_dir}/mkpasswd" \
    --print-out-paths
)"
psmisc_path="$(
  nix "${nix_flags[@]}" build "${flake_ref}#nixosConfigurations.nixbook.pkgs.psmisc" \
    --out-link "${install_data_dir}/psmisc" \
    --print-out-paths
)"
fuser_bin="${psmisc_path}/bin/fuser"
[[ -x ${fuser_bin} ]] || die "the prebuilt fuser executable is missing."

verify_target_unchanged

"${disko_install_path}/bin/disko-install" \
  "${disko_args[@]}" \
  --dry-run

nix "${nix_flags[@]}" build \
  "${flake_ref}#nixosConfigurations.nixbook.config.system.build.toplevel" \
  --out-link "${install_data_dir}/system"
system_path="$(readlink -e -- "${install_data_dir}/system")" || die "cannot resolve the prebuilt system."
path_info="$(nix "${nix_flags[@]}" path-info -S "${system_path}")" ||
  die "cannot calculate the system closure size."
read -r _ closure_bytes <<<"${path_info}"
[[ ${closure_bytes} =~ ^[0-9]+$ ]] || die "Nix returned an invalid closure size."
disk_bytes="$(blockdev --getsize64 "${resolved_target}")"
required_bytes=$((closure_bytes + swap_bytes + esp_bytes + free_margin_bytes))
((disk_bytes >= required_bytes)) ||
  die "the current system needs at least $(((required_bytes + 1024 * 1024 * 1024 - 1) / 1024 / 1024 / 1024)) GiB including swap and safety margin, but the disk has $((disk_bytes / 1024 / 1024 / 1024)) GiB."

original_umask="$(umask)"
umask 077

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

read_hash root "${install_data_dir}/passwordFiles/root"
read_hash chen "${install_data_dir}/passwordFiles/chen"

read_luks_password() {
  local password password_confirm

  while true; do
    printf 'New LUKS disk-encryption password: ' >/dev/tty
    read -r -s password </dev/tty
    printf '\nRepeat LUKS disk-encryption password: ' >/dev/tty
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

printf '\nAll preflight checks passed. The following disk will be permanently erased:\n\n'
show_target_tree
printf '\nType "ERASE %s" to continue: ' "${target_disk}"
read -r confirmation </dev/tty
if [[ ${confirmation} != "ERASE ${target_disk}" ]]; then
  die "confirmation did not match. Nothing was changed."
fi

check_efi_state
verify_target_unchanged
validate_install_data
set_disko_args

"${disko_install_path}/bin/disko-install" \
  "${disko_args[@]}" \
  --extra-files "${install_data_dir}/passwordFiles/root" /persist/passwordFiles/root \
  --extra-files "${install_data_dir}/passwordFiles/chen" /persist/passwordFiles/chen \
  --extra-files "${install_data_dir}/machine-id" /persist/etc/machine-id

printf '\nInstallation finished. Reboot and remove the installation media.\n'
