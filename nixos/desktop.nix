{
  services.xserver = {
    enable = true;
    layout = "us";

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
    
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

  programs.dconf.enable = true;
  services.udisks2.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
  };
}
