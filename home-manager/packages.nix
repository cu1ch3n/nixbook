{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    activitywatch
    discord
    element-desktop
    # evolution
    gh
    gimp-with-plugins
    gnumake
    inkscape
    marvin
    obsidian
    okular
    qq
    screenfetch
    slack
    spotify
    tree
    v2raya
    vlc
    wineWowPackages.waylandFull
    wpsoffice
    yesplaymusic
    zoom-us
    # nur.repos.xddxdd.wine-wechat
  ];
}
