{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eyedropper
  ];
  dconf.settings."com/github/finefindus/eyedropper" = {
    visible-formats = [
      "name"
      "hex"
      "rgb"
    ];
  };
}
