{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    ./development
    ./programs
    ./packages.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      inputs.nix-vscode-extensions.overlays.default
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      permittedInsecurePackages = [
        "openssl-1.1.1w"
        "electron-19.1.9"
        "electron-25.9.0"
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
