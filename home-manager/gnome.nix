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
        "Vitals@CoreCoding.com"
        "pop-shell@system76.com"
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

    "org/gnome/shell/extensions/space-bar/appearance" = {
      workspace-margin = 0;
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      always-show-numbers = true;
      indicator-style = "workspaces-bar";
      position = "right";
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
      tile-by-default = true;
      hint-color-rgba = "rgba(38, 194, 129, 1)";
    };

    "org/gnome/shell/extensions/space-bar/shortcuts" = {
      enable-activate-workspace-shortcuts = true;
      enable-move-to-workspace-shortcuts = true;
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = ["dateMenu"];
      left-box-order = ["activities" "menuButton" "Space Bar" "appMenu"];
      right-box-order = [
        "vitalsMenu"
        "appindicator-kstatusnotifieritem-chrome_status_icon_1"
        "appindicator-kstatusnotifieritem-tao application"
        "appindicator-kstatusnotifieritem-Fcitx"
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
        "_system_uptime_"
      ];
      memory-measurement = 1;
      show-battery = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

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
    dconf-editor
    gsconnect
    just-perfection
    logo-menu
    pano
    pop-shell
    (space-bar.override {
      version = "23";
      metadata = "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIlJlcGxhY2VzIHRoZSAnQWN0aXZpdGllcycgYnV0dG9uIHdpdGggYW4gaTMtbGlrZSB3b3Jrc3BhY2VzIGJhci5cblxuT3JpZ2luYWxseSBhIGZvcmsgb2YgdGhlIGV4dGVuc2lvbiBXb3Jrc3BhY2VzIEJhciBieSBmdGh4LCB0aGlzIGV4dGVuc2lvbiBncmV3IGludG8gYSBtb3JlIGNvbXByZWhlbnNpdmUgc2V0IG9mIGZlYXR1cmVzIHRvIHN1cHBvcnQgYSB3b3Jrc3BhY2UtYmFzZWQgd29ya2Zsb3cuXG5cbkZlYXR1cmVzOlxuLSAgIEZpcnN0IGNsYXNzIHN1cHBvcnQgZm9yIHN0YXRpYyBhbmQgZHluYW1pYyB3b3Jrc3BhY2VzIGFzIHdlbGwgYXMgbXVsdGktbW9uaXRvciBzZXR1cHNcbi0gICBBZGQsIHJlbW92ZSwgYW5kIHJlbmFtZSB3b3Jrc3BhY2VzXG4tICAgUmVhcnJhbmdlIHdvcmtzcGFjZXMgdmlhIGRyYWcgYW5kIGRyb3Bcbi0gICBBdXRvbWF0aWNhbGx5IGFzc2lnbiB3b3Jrc3BhY2UgbmFtZXMgYmFzZWQgb24gc3RhcnRlZCBhcHBsaWNhdGlvbnNcbi0gICBLZXlib2FyZCBzaG9ydGN1dHMgZXh0ZW5kIGFuZCByZWZpbmUgc3lzdGVtIHNob3J0Y3V0c1xuLSAgIFNjcm9sbCB0aHJvdWdoIHdvcmtzcGFjZXMgYnkgbW91c2Ugd2hlZWwgb3ZlciB0aGUgcGFuZWxcbi0gICBDdXN0b21pemUgdGhlIGFwcGVhcmFuY2UiLAogICJuYW1lIjogIlNwYWNlIEJhciIsCiAgInNldHRpbmdzLXNjaGVtYSI6ICJvcmcuZ25vbWUuc2hlbGwuZXh0ZW5zaW9ucy5zcGFjZS1iYXIiLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ1IgogIF0sCiAgInVybCI6ICJodHRwczovL2dpdGh1Yi5jb20vY2hyaXN0b3BoZXItbC9zcGFjZS1iYXIiLAogICJ1dWlkIjogInNwYWNlLWJhckBsdWNocmlvaCIsCiAgInZlcnNpb24iOiAyMwp9";
      sha256 = "sha256-wlY/wfkA0Ty3SopFuwfbF11AObb70XPy/ugoelefqrM=";
    })
    top-bar-organizer
    vitals
  ];
}
