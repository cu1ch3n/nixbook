{ lib, ... }:
{
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=16G"
          "mode=755"
        ];
      };

      "/nix" = {
        fsType = "none";
        device = "/persist/nix";
        mountOptions = [ "bind" ];
      };

      "/var/log" = {
        fsType = "none";
        device = "/persist/var/log";
        mountOptions = [ "bind" ];
      };

      "/tmp" = {
        fsType = "none";
        device = "/persist/tmp";
        mountOptions = [ "bind" ];
      };

      "/swap" = {
        fsType = "none";
        device = "/persist/swap";
        mountOptions = [ "bind" ];
      };
    };

    disk.main = {
      type = "disk";
      # The standalone installer wrapper replaces this value with its required
      # `device` argument. This invalid default prevents an unqualified wipe.
      device = lib.mkDefault "/dev/disk/by-id/CHANGE-ME";

      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            label = "nixbook-ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
            };
          };

          luks = {
            label = "nixbook-LUKS";
            size = "100%";
            content = {
              type = "luks";
              name = "nixbook-crypted";
              # install.sh creates this root-only temporary file in the live environment.
              # It is used only while Disko formats and opens the new LUKS volume.
              passwordFile = "/run/nixbook-install/luks-password";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/persist";
                extraArgs = [
                  "-F"
                  "-m"
                  "1"
                ];
                mountOptions = [ "noatime" ];
                postMountHook = ''
                  persistent_root="$(findmnt -nr -o TARGET --source "$device" | head -n1)"
                  test -n "$persistent_root"
                  install -d -m 0755 \
                    "$persistent_root/nix" \
                    "$persistent_root/etc" \
                    "$persistent_root/var/log"
                  install -d -m 0700 "$persistent_root/passwordFiles"
                  install -d -m 1777 "$persistent_root/tmp"
                  install -d -m 0700 "$persistent_root/swap"
                '';
              };
            };
          };
        };
      };
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 32 * 1024;
    }
  ];
}
