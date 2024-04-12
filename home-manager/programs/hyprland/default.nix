{ pkgs
, inputs
, ...
}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
      # hyprbars
    ];
  };

  home.packages = with pkgs; [
    wofi
    wlogout
  ];
}
