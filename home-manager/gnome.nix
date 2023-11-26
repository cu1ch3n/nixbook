{ pkgs
, lib
, ...
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
        "Vitals@CoreCoding.com"
      ];
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
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
        # "Vitals@CoreCoding.com"
        "pop-shell@system76.com"
        "kimpanel@kde.org"
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

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [
        "chromium-browser.desktop:1"
        "org.gnome.Nautilus.desktop:2"
        "qq.desktop:4"
        "discord.desktop:4"
        "wine-wechat.desktop:4"
        "spotify.desktop:5"
        "yesplaymusic.desktop:5"
        "org.gnome.Extensions.desktop:6"
        "org.gnome.Settings.desktop:6"
      ];
    };

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = false;
      indicator-position-max = 2;
      show-indicator = "only-active";
    };

    "org/gnome/shell/extensions/kimpanel" = {
      font = "Source Han Sans SC 11";
    };

    "org/gnome/shell/extensions/Logo-menu" = {
      hide-forcequit = false;
      hide-softwarecentre = true;
      menu-button-icon-click-type = 3;
      menu-button-icon-image = 18;
      menu-button-icon-size = 22;
      menu-button-terminal = "alacritty";
      show-lockscreen = true;
      show-power-options = true;
      symbolic-icon = false;
    };

    "org/gnome/shell/extensions/pano" = {
      play-audio-on-copy = false;
      send-notification-on-copy = false;
    };

    "org/gnome/shell/extensions/space-bar/appearance" = {
      workspace-margin = 0;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = true;
      indicator-style = "workspaces-bar";
      position = "left";
      position-index = 2;
      smart-workspace-names = false;
      toggle-overview = false;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = true;
      activities-button = false;
      app-menu = false;
      app-menu-icon = false;
      app-menu-label = false;
      dash-icon-size = 0;
      panel = true;
      panel-in-overview = true;
      ripple-box = true;
      search = true;
      show-apps-button = true;
      startup-status = 1;
      theme = false;
      window-demands-attention-focus = true;
      window-picker-icon = true;
      workspace = true;
      workspaces-in-app-grid = true;
      workspace-wrap-around = true;
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
      tile-by-default = false;
      hint-color-rgba = "rgba(38, 194, 129, 1)";
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-activate-workspace-shortcuts = true;
      enable-move-to-workspace-shortcuts = true;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = [ "dateMenu" ];
      left-box-order = [ "activities" "LogoMenu" "menuButton" "appMenu" "Space Bar" ];
      right-box-order = [
        # "vitalsMenu"
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

    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = true;
      hide-icons = false;
      hide-zeros = false;
      hot-sensors = [
        "__network-tx_max__"
        "__network-rx_max__"
        "_processor_usage_"
        "__temperature_avg__"
        "_memory_free_"
      ];
      memory-measurement = 1;
      show-battery = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "default";
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
      num-workspaces = 7;
      workspace-names = [ "🌐" "🗄️" "🐓" "💬" "🎵" "❄️" "😅" ];
      titlebar-font = "Inter 11";
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
      dconf-editor
      gnome-tweaks
      gsconnect
      just-perfection
      kimpanel
      logo-menu
      # pano
      pop-shell
      space-bar
      top-bar-organizer
      vitals
    ];
}
