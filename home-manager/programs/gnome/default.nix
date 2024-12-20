{ pkgs, ... }:
{
  imports = [
    ./paperwm.nix
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
        "gsconnect@andyholmes.github.io"
        "kimpanel@kde.org"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "pano@elhan.io"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "htop.desktop"
        "1password.desktop"
        "chromium-browser.desktop"
        "code.desktop"
        "sublime_text.desktop"
        "sublime_merge.desktop"
        "slack.desktop"
        "discord.desktop"
        "com.tencent.wechat.desktop"
        "Zoom.desktop"
        "yesplaymusic.desktop"
        "steam.desktop"
        "Waydroid.desktop"
        "v2raya.desktop"
      ];
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ./wallpapers/sun.png;
      picture-uri-dark = "file://" + ./wallpapers/comet.png;
    };

    "org/gnome/desktop/interface" = {
      cursor-theme = "phinger-cursors-light";
      cursor-size = 32;
      enable-animations = true;
      enable-hot-corners = false;
      gtk-enable-primary-paste = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/search-providers" = {
      enabled = [ "org.gnome.Weather.desktop" ];
      disabled = [ "org.gnome.Contacts.desktop" ];
    };

    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = false;
      indicator-position-max = 2;
      show-indicator = "only-active";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      hot-keys = false;
      transparency-mode = "FIXED";
      background-opacity = 0.5;
      multi-monitor = true;
    };

    "org/gnome/shell/extensions/kimpanel" = {
      font = "Source Han Sans SC 11";
    };

    "org/gnome/shell/extensions/pano" = {
      paste-on-select = false;
      play-audio-on-copy = false;
      send-notification-on-copy = false;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-saver-profile-on-low-battery = false;
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-ac-type = "nothing";
    };
  };

  xdg.mimeApps.associations.added = {
    "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
    "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
  };

  home.packages =
    with pkgs;
    with gnome;
    with gnomeExtensions;
    [
      alphabetical-app-grid
      appindicator
      caffeine
      dash-to-dock
      dconf2nix
      pkgs.dconf-editor
      fastfetch
      pkgs.gnome-tweaks
      gsconnect
      kimpanel
      libnotify
      pano
      phinger-cursors
    ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.file.".face".source = ./face.jpg;
}
