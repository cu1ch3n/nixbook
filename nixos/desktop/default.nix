{
  imports = [./fonts.nix];

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
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
