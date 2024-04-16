{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-gui
    axel
    bilibili
    discord
    evolution
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
