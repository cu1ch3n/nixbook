{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs
    jetbrains.webstorm
  ];
}
