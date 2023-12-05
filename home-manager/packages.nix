{ pkgs, ... }: {
  home.packages = with pkgs; [
    _1password-gui
    activitywatch
    axel
    discord
    element-desktop
    etcher
    evolution
    gh
    gimp-with-plugins
    gnumake
    inkscape
    inotify-tools
    marvin
    obsidian
    okular
    qq
    screenfetch
    slack
    spotify
    tree
    vlc
    wineWowPackages.waylandFull
    wpsoffice
    yesplaymusic
    zoom-us
    # nur.repos.xddxdd.wine-wechat
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "okular.desktop";
    };
  };
}
