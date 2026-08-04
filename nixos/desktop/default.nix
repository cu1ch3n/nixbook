{ ... }:
{
  imports = [
    ./fonts.nix
  ];

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    desktopManager.gnome.enable = true;
    displayManager = {
      defaultSession = "gnome";
      gdm.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    gvfs.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security = {
    pam.services.gdm = {
      enableGnomeKeyring = true;
      fprintAuth = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  virtualisation.waydroid.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

}
