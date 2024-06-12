{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    ./development
    ./dotfiles
    ./programs
    ./packages.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.master-packages
      inputs.nix-vscode-extensions.overlays.default
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };

  home = {
    username = "chen";
    homeDirectory = "/home/chen";
    sessionPath = ["$HOME/bin"];
  };

  xdg.mimeApps.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
