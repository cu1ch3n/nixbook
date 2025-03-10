{ pkgs, ... }:
{
  home.packages = with pkgs; [
    axel
    brightnessctl
    discord
    evolution
    firefox
    gh
    gnumake
    inkscape
    inotify-tools
    just
    kdenlive
    lm_sensors
    logseq
    obsidian
    oh-my-git
    okular
    qbittorrent
    qq
    quartz
    screenfetch
    slack
    snipaste
    spotify
    strawberry
    sublime-merge
    telegram-desktop
    tree
    vlc
    via
    wechat-uos
    wineWowPackages.waylandFull
    zoom-us
  ];

  xdg.mimeApps = {
    associations.added = {
      "application/pdf" = "okular.desktop";
    };
    defaultApplications = {
      "application/pdf" = "okular.desktop";
    };
  };
}
