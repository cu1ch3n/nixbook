{pkgs, ...}: {
  home.packages = with pkgs; [
    axel
    bilibili
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
    oh-my-git
    okular
    qbittorrent
    qq
    screenfetch
    slack
    snipaste
    spotify
    strawberry
    sublime-merge
    tree
    vlc
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
