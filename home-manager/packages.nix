{pkgs, ...}: {
  home.packages = with pkgs; [
    axel
    discord
    evolution
    firefox
    gh
    gnumake
    inkscape
    inotify-tools
    just
    kdenlive
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
    wineWowPackages.waylandFull
    yesplaymusic
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
