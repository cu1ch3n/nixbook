{ pkgs, inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs = {
    plasma = {
      enable = true;
      workspace = {
        wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/contents/images/5120x2880.png";
      };
    };
  };
}
