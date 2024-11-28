{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wpsoffice-cn
  ];
}
