{pkgs, ...}: {
  home.packages = with pkgs; [
    axel
    bilibili
    discord
    # evolution
    firefox
    gh
    gnumake
    inkscape
    inotify-tools
    just
    okular
    qbittorrent
    qq
    screenfetch
    slack
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
