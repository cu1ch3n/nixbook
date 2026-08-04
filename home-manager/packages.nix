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
    obsidian
    oh-my-git
    opencode-desktop
    kdePackages.okular
    qbittorrent
    qq
    quartz
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
    wineWow64Packages.waylandFull
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
