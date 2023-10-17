{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    gnumake
    qq
    screenfetch
    slack
    tree
    vlc
    zoom-us
  ];
}
