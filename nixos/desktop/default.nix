{
  imports = [ ./fonts.nix ];

  services.xserver = {
    enable = true;
    xkb.layout = "us";
  };
  services.displayManager = {
    # sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };
    # defaultSession = "plasma";
    gdm.enable = true;
  };
  # services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;
  services.libinput.enable = true;

  # For trash
  services.gvfs.enable = true;

  virtualisation.waydroid.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
