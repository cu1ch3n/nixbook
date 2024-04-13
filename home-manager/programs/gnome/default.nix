{ pkgs, ... }: {
  dconf.settings = {
    "org/gnome/shell" = {
      disabled-extensions = [
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "gsconnect@andyholmes.github.io"
        "kimpanel@kde.org"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "pano@elhan.io"
        "top-bar-organizer@julian.gse.jsts.xyz"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "chromium-browser.desktop"
        "code.desktop"
        "slack.desktop"
        "yesplaymusic.desktop"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      sigma = 200;
      brightness = 0.9;
    };

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = false;
      indicator-position-max = 2;
      show-indicator = "only-active";
    };

    "org/gnome/shell/extensions/kimpanel" = {
      font = "Source Han Sans SC 11";
    };

    "org/gnome/shell/extensions/pano" = {
      play-audio-on-copy = false;
      send-notification-on-copy = false;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = [ "dateMenu" ];
      left-box-order = [
        "activities"
        "menuButton"
        "appMenu"
      ];
      right-box-order = [
        "appindicator-kstatusnotifieritem-chrome_status_icon_1"
        "appindicator-kstatusnotifieritem-tao application"
        "appindicator-kstatusnotifieritem-Fcitx"
        "kimpanel"
        "pop-shell"
        "pano@elhan.io"
        "screenRecording"
        "screenSharing"
        "dwellClick"
        "a11y"
        "keyboard"
        "quickSettings"
      ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
      cursor-theme = "phinger-cursors";
      document-font-name = "Inter 11";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "Inter 11";
      monospace-font-name = "JetBrains Mono 10";
      show-battery-percentage = true;
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 9;
      titlebar-font = "Inter 11";
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ./wallpapers/sun.png;
      picture-uri-dark = "file://" + ./wallpapers/comet.png;
    };
  };

  xdg.mimeApps.associations.added = {
    "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
    "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
  };

  home.packages = with pkgs;
    with gnome;
    with gnomeExtensions; [
      alphabetical-app-grid
      appindicator
      blur-my-shell
      caffeine
      dconf2nix
      dconf-editor
      gnome-tweaks
      gsconnect
      kimpanel
      pano
      top-bar-organizer
    ];

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 48;
    gtk.enable = true;
  };
}
