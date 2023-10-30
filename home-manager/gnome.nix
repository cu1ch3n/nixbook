{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "chromium-browser.desktop"
        "code.desktop"
        "slack.desktop"
        "clash-verge.desktop"
      ];

      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Hide_Activities@shay.shayel.org"
        "logomenu@aryan_k"
        # "pop-shell@system76.com"
        "top-bar-organizer@julian.gse.jsts.xyz"
        # "Vitals@CoreCoding.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];

      "extensions/top-bar-organizer/left-box-order" = [
        "activities"
        "menuButton"
        "appMenu"
      ];

      "extensions/top-bar-organizer/center-box-order" = [
        "dateMenu"
      ];

      "extensions/top-bar-organizer/right-box-order" = [
        # "vitalsMenu"
        # "pop-shell"
        "workspace-indicator"
        "appindicator-kstatusnotifieritem-tao application"
        "appindicator-kstatusnotifieritem-Fcitx"
        "screenRecording"
        "screenSharing"
        "dwellClick"
        "a11y"
        "keyboard"
        "quickSettings"
      ];

      "extensions/Logo-menu/menu-button-icon-image" = 45;
      "extensions/Logo-menu/menu-button-icon-size" = 22;
      "extensions/Logo-menu/hide-softwarecentre" = true;
      "extensions/Logo-menu/menu-button-terminal" = "alacritty";
      "extensions/Logo-menu/show-power-options" = true;
      "extensions/Logo-menu/show-lockscreen" = true;
    };
    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
  };

  home.packages = with pkgs; with gnomeExtensions; [
    appindicator
    auto-move-windows
    caffeine
    dconf2nix
    gsconnect
    hide-activities-button
    logo-menu
    # pop-shell
    top-bar-organizer
    # vitals
  ];
}
