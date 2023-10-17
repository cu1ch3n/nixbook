{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    qq
    screenfetch
    vlc
  ];
}
