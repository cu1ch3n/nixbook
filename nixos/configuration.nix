{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./desktop
    ./hardware.nix
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
    ./secrets.nix
    ./user.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.master-packages
      inputs.nur.overlay
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

  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init
    [openssl_init]
    ssl_conf = ssl_sect
    [ssl_sect]
    system_default = system_default_sect
    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
    [system_default_sect]
    CipherString = Default:@SECLEVEL=0
  '';

  environment.systemPackages = with pkgs; [
    git
    htop
    wget
    v2raya
  ];

  services.ntp.enable = true;
  services.v2raya.enable = true;
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
  security.sudo.execWheelOnly = true;
  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ "chen" ];

  programs.nix-ld.enable = true;

  system.stateVersion = "24.11";
}
