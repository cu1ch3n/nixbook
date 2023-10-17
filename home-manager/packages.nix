{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    gnumake
    okular
    qq
    screenfetch
    slack
    tree
    vlc
    zoom-us
  ];
}
