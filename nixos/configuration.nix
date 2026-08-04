{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ../scripts/disko.nix
    ./desktop
    ./hardware.nix
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
    ./secrets.nix
    ./user.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.nur.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  home-manager = {
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users.chen = import ../home-manager/home.nix;
  };

  networking = {
    hostName = "nixbook";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      git
      htop
      wget
      v2raya
      hapi
      cc-switch
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  services = {
    # VIA ships the hidraw access rule in its package; Home Manager alone cannot
    # install that system-level rule.
    udev.packages = [ pkgs.via ];

    openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persist/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
      openFirewall = false;
    };

    ntp.enable = true;
    v2raya.enable = true;
    mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };
  };

  security.sudo.execWheelOnly = true;
  virtualisation.docker.enable = true;

  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableExtensionPack = true;
  # };
  # users.extraGroups.vboxusers.members = [ "chen" ];

  programs.nix-ld.enable = true;

  system.stateVersion = "26.05";
}
