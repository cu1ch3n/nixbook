{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    discord
    evolution
    gimp-with-plugins
    gnumake
    inkscape
    jetbrains.pycharm-community
    obsidian
    okular
    qq
    screenfetch
    slack
    spotify
    tree
    vlc
    wineWowPackages.waylandFull
    wpsoffice
    yesplaymusic
    zoom-us
  ];
}
