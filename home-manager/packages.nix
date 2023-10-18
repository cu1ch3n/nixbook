{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    gnumake
    okular
    qq
    screenfetch
    slack
    spotify
    tree
    vlc
    wineWowPackages.waylandFull
    zoom-us
  ];
}
