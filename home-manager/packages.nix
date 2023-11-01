{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    discord
    gnumake
    linuxKernel.packages.linux_latest_libre.cpupower
    obsidian
    okular
    qq
    screenfetch
    slack
    spotify
    tree
    vlc
    wineWowPackages.waylandFull
    yesplaymusic
    zoom-us
  ];
}
