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
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        # "pop-shell@system76.com"
        "top-bar-organizer@julian.gse.jsts.xyz"
        # "Vitals@CoreCoding.com"
        "Hide_Activities@shay.shayel.org"
      ];

      "extensions/top-bar-organizer/left-box-order" = [
        "activities"
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
    };
    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
  };

  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    hide-activities-button
    # pop-shell
    top-bar-organizer
    # vitals
  ];
}
