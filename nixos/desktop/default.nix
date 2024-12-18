{ pkgs, inputs, ... }:
{
  imports = [
    ./fonts.nix
  ];

  # services.xserver = {
  #   enable = true;
  #   xkb.layout = "us";
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # };

  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #   };
  #   defaultSession = "plasma";
  # };
  # services.desktopManager.plasma6.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.gnome.enable = true;
  };

  services.displayManager = {
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.libinput.enable = true;

  # For trash
  services.gvfs.enable = true;

  virtualisation.waydroid.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
