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
  };

  services.desktopManager.gnome.enable = true;

  services.displayManager = {
    defaultSession = "gnome";
    gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };

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

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
