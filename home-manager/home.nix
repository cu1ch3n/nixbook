{ inputs
, outputs
, config
, ...
}: {
  imports = [
    ./development
    ./programs
    ./packages.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.nix-vscode-extensions.overlays.default
      inputs.nur.overlay

      # You can also add oinputs.nix-vscode-extensions-overlayverlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-19.1.9"
      ];
    };
  };

  home = {
    username = "chen";
    homeDirectory = "/home/chen";
    sessionPath = [ "$HOME/bin" ];
  };

  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
