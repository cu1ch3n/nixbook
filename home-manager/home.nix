{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./development
    ./dotfiles
    ./programs
    ./packages.nix
    inputs.nix-colors.homeManagerModules.default
    inputs.nix-clawdbot.homeManagerModules.clawdbot
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.master-packages
      inputs.nix-vscode-extensions.overlays.default
      inputs.nur.overlays.default
      inputs.nix-clawdbot.overlays.default
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-27.3.11"
      ];
    };
  };

  home = {
    username = "chen";
    homeDirectory = "/home/chen";
    sessionPath = [ "$HOME/bin" ];
  };

  xdg.mimeApps.enable = true;
  fonts.fontconfig.enable = true;
  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
