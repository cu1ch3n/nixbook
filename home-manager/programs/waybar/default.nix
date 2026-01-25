{ pkgs, ... }:
{
  xdg.configFile."waybar" = {
    source = ./.;
    recursive = true;
  };

  xdg.configFile."rofi" = {
    source = ./rofi;
    recursive = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    rofi
    waybar-mpris
  ];
}
