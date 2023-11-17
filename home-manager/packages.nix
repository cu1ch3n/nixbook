{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    activitywatch
    discord
    # evolution
    gh
    gimp-with-plugins
    gnumake
    inkscape
    marvin
    nixpkgs-fmt
    nixpkgs-review
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
    # nur.repos.xddxdd.wine-wechat
  ];
}
