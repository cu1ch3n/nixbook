{
  pkgs,
  lib,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disabled-extensions = [
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Hide_Activities@shay.shayel.org"
        "logomenu@aryan_k"
        "caffeine@patapon.info"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
        "space-bar@luchrioh"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "pano@elhan.io"
        "just-perfection-desktop@just-perfection"
        "AlphabeticalAppGrid@stuarthayhurst"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "chromium-browser.desktop"
        "code.desktop"
        "slack.desktop"
        "yesplaymusic.desktop"
        "clash-verge.desktop"
      ];
    };

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = false;
      indicator-position-max = 2;
      show-indicator = "only-active";
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = true;
      app-menu = true;
      app-menu-icon = true;
      dash-icon-size = 0;
      panel = true;
      panel-in-overview = true;
      ripple-box = true;
      search = true;
      show-apps-button = true;
      startup-status = 1;
      theme = false;
      window-demands-attention-focus = false;
      window-picker-icon = true;
      workspace = true;
      workspaces-in-app-grid = true;
    };

    "org/gnome/shell/extensions/Logo-menu" = {
      hide-forcequit = false;
      hide-softwarecentre = true;
      menu-button-icon-click-type = 3;
      menu-button-icon-image = 45;
      menu-button-icon-size = 22;
      menu-button-terminal = "alacritty";
      show-lockscreen = true;
      show-power-options = true;
    };

    "org/gnome/shell/extensions/pano" = {
      play-audio-on-copy = false;
      send-notification-on-copy = false;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      indicator-style = "workspaces-bar";
      position = "right";
      always-show-numbers = false;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = ["dateMenu"];
      left-box-order = ["activities" "menuButton" "appMenu"];
      right-box-order = [
        "Space Bar"
        "appindicator-kstatusnotifieritem-chrome_status_icon_1"
        "appindicator-kstatusnotifieritem-tao application"
        "appindicator-kstatusnotifieritem-Fcitx"
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

    "org/gnome/desktop/interface".show-battery-percentage = true;

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 7;
      workspace-names = ["🌐" "🗄️" "🐓" "💬" "🎵" "⚙️" "😅"];
    };
  };

  home.packages = with pkgs;
  with gnome;
  with gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    auto-move-windows
    blur-my-shell
    caffeine
    dconf2nix
    gsconnect
    hide-activities-button
    just-perfection
    logo-menu
    pano
    space-bar
    top-bar-organizer
    dconf-editor
  ];
}
