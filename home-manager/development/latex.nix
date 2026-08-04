{ pkgs, ... }:
{
  home.packages = with pkgs; [
    texliveFull
    python3Packages.pygments
  ];
}
