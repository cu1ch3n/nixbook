{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    discord
    gimp-with-plugins
    gnumake
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
