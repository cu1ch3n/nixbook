{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    activitywatch
    discord
    evolution
    gimp-with-plugins
    gnumake
    inkscape
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
    nur.repos.xddxdd.wine-wechat
  ];
}
