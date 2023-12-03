{ pkgs, ... }:
let
  rime-ice-pkg = pkgs.callPackage ./rime-ice.nix { };
in
{
  xdg.dataFile = {
    "fcitx5/rime" = {
      source = "${rime-ice-pkg}/share/rime-data";
      recursive = true;
    };
  };
}
