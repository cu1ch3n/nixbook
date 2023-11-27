{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./desktop
    ./hardware.nix
    ./locale.nix
    ./nix.nix
    ./user.nix
    ./virtualisation.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  networking = {
    hostName = "nixbook";
    networkmanager.enable = true;
    proxy.noProxy = "127.0.0.1,localhost,.localdomain";
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

  environment.systemPackages = with pkgs; [ git htop wget ];
  services.ntp.enable = true;

  services.v2raya.enable = true;

  system.stateVersion = "23.11";
}
