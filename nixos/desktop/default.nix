{ pkgs
, inputs
, ...
}:
{
  imports = [ ./fonts.nix ];

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    libinput.enable = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
