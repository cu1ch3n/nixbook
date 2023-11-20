{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    activitywatch
    clash-verge
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
    v2raya
    vlc
    wineWowPackages.waylandFull
    wpsoffice
    yesplaymusic
    zoom-us
    # nur.repos.xddxdd.wine-wechat
  ];
}
