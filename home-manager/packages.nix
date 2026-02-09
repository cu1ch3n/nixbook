{ pkgs, ... }:
{
  home.packages = with pkgs; [
    axel
    brightnessctl
    discord
    # evolution
    firefox
    gh
    gnumake
    happy-coder
    inkscape
    inotify-tools
    just
    # kdePackages.kdenlive
    lm_sensors
    logseq
    obsidian
    oh-my-git
    kdePackages.okular
    qbittorrent
    qq
    quartz
    claudecodeui
    hapi
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
    zotero
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
