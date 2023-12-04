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

  home.file = {
    ".config/fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=rime

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=rime
      Layout=

      [GroupOrder]
      0=Default
    '';
  };
}
