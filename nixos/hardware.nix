{ inputs
, config
, lib
, pkgs
, ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.hardware.nixosModules.common-pc-laptop-ssd
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "synaptics_usb" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ ];

  # disable Scatter/Gather APU recently enabled by default,
  # which results in white screen after display reconfiguration
  boot.kernelParams = [
    "amdgpu.sg_display=0"
    "amd_pstate=active"
  ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=8G" "mode=755" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nix";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  # Power saving
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # Fingerprint
  # services.fprintd.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
