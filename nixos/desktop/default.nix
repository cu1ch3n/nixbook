{
  imports = [ ./fonts.nix ];

  services.xserver = {
    enable = true;
    layout = "us";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    libinput.enable = true;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
  };
}
