{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "synaptics_usb" ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];

    # Disable Scatter/Gather APU, which causes a white screen after display
    # reconfiguration on this machine.
    kernelParams = [ "amdgpu.sg_display=0" ];
    tmp.cleanOnBoot = true;
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Disko owns the filesystem, bind-mount, and LUKS declarations. These mounts
  # must be available before the Nix store, impermanence, and journald start.
  fileSystems = {
    "/persist".neededForBoot = true;
    "/nix" = {
      neededForBoot = true;
      depends = [ "/persist" ];
    };
    "/var/log" = {
      neededForBoot = true;
      depends = [ "/persist" ];
    };
    "/tmp".depends = [ "/persist" ];
    "/swap".depends = [ "/persist" ];
  };

  # sound = {
  #   enable = lib.mkForce false;
  #   mediaKeys.enable = true;
  # };

  # hardware.pulseaudio = {
  #   enable = true;
  #   support32Bit = true;
  # };

  services = {
    fprintd.enable = true;
    printing.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
