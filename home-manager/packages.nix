{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    qq
    screenfetch
    slack
    vlc
    zoom-us
  ];
}
