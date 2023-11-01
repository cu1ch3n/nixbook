{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    discord
    gnumake
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
