{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disabled-extensions = [
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Hide_Activities@shay.shayel.org"
        "logomenu@aryan_k"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "caffeine@patapon.info"
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
        "clipboard-history@alexsaveau.dev"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "chromium-browser.desktop"
        "code.desktop"
        "slack.desktop"
        "clash-verge.desktop"
      ];
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

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = false;
      indicator-position-max = 2;
      show-indicator = "only-active";
    };

    "org/gnome/shell/extensions/top-bar-organizer" = {
      center-box-order = ["dateMenu"];
      left-box-order = ["activities" "menuButton" "appMenu"];
      right-box-order = [
        "workspace-indicator"
        "appindicator-kstatusnotifieritem-tao application"
        "appindicator-kstatusnotifieritem-Fcitx"
        "Clipboard History Indicator"
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
  };

  home.packages = with pkgs;
  with gnomeExtensions; [
    appindicator
    auto-move-windows
    blur-my-shell
    caffeine
    clipboard-history
    dconf2nix
    gsconnect
    hide-activities-button
    logo-menu
    top-bar-organizer
  ];
}
