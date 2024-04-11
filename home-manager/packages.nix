{ pkgs, ... }: {
  home.packages = with pkgs; [
    _1password-gui
    axel
    evolution
    gh
    gnumake
    inkscape
    inotify-tools
    obsidian
    okular
    qq
    screenfetch
    slack
    spotify
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
