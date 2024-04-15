{
  lib,
  pkgs,
  ...
}:
with builtins;
with lib.attrsets;
with lib.lists; let
  paperwm-workspaces = "org/gnome/shell/extensions/paperwm/workspaces";
  workspace-ids = [
    "19f297b6-e5c3-40f8-b2e8-4bcf2909417f"
    "dde9f204-86bd-4d17-8fd8-8564a00528da"
    "f4208d88-d6dc-4c79-997a-9802b29f5977"
    "39be82fc-e02c-4f9b-b32d-660626e4456c"
    "27e88c82-463c-4533-b801-111f0bb2c493"
    "0b58cd0c-22dd-4da0-be7e-8e067a7b9e9b"
    "a49110b6-b1d4-4521-8e9f-369d52050eb0"
    "a2822780-814e-490a-9d93-e63d37af7033"
    "a3809c53-0695-4d0d-a312-be51057d0f5b"
  ];
  workspaces-to-configs = ws-configs:
    listToAttrs (
      zipListsWith (id-pair: ws-config:
        nameValuePair "${paperwm-workspaces}/${toString id-pair.fst}" (ws-config // {index = id-pair.snd;}))
      (zipLists workspace-ids (range 0 9))
      ws-configs
    );
in {
  dconf.settings =
    {
      "org/gnome/shell" = {
        disabled-extensions = [
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "light-style@gnome-shell-extensions.gcampax.github.com"
          "places-menu@gnome-shell-extensions.gcampax.github.com"
          "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "window-list@gnome-shell-extensions.gcampax.github.com"
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        ];
        enabled-extensions = [
          "AlphabeticalAppGrid@stuarthayhurst"
          "appindicatorsupport@rgcjonas.gmail.com"
          "caffeine@patapon.info"
          "gsconnect@andyholmes.github.io"
          "kimpanel@kde.org"
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          "switcher@landau.fi"
          "pano@elhan.io"
          "paperwm@paperwm.github.com"
        ];
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "Alacritty.desktop"
          "chromium-browser.desktop"
          "code.desktop"
          "slack.desktop"
          "com.tencent.wechat.desktop"
          "yesplaymusic.desktop"
          "v2raya.desktop"
        ];

        last-selected-power-profile = "power-saver";
      };

      "org/gnome/desktop/search-providers" = {
        enabled = ["org.gnome.Weather.desktop"];
        disabled = ["org.gnome.Contacts.desktop"];
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

      "org/gnome/shell/extensions/paperwm" = {
        horizontal-margin = 10;
        window-gap = 10;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/shell/extensions/switcher" = {
        workspace-indicator = true;
      };

      "org/gnome/desktop/interface" = {
        cursor-theme = "phinger-cursors-light";
        cursor-size = 32;
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

      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-5 = ["<Super>5"];
        switch-to-workspace-6 = ["<Super>6"];
        switch-to-workspace-7 = ["<Super>7"];
        switch-to-workspace-8 = ["<Super>8"];
        switch-to-workspace-9 = ["<Super>9"];

        move-to-workspace-1 = ["<Super><Shift>1"];
        move-to-workspace-2 = ["<Super><Shift>2"];
        move-to-workspace-3 = ["<Super><Shift>3"];
        move-to-workspace-4 = ["<Super><Shift>4"];
        move-to-workspace-5 = ["<Super><Shift>5"];
        move-to-workspace-6 = ["<Super><Shift>6"];
        move-to-workspace-7 = ["<Super><Shift>7"];
        move-to-workspace-8 = ["<Super><Shift>8"];
        move-to-workspace-9 = ["<Super><Shift>9"];

        close = ["<Super>q"];
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

      "${paperwm-workspaces}" = {
        list = workspace-ids;
      };
    }
    // workspaces-to-configs [
      {name = "Web Browsing";}
      {name = "File Management";}
      {name = "Research";}
      {name = "Coding";}
      {name = "Communication";}
      {name = "Music";}
      {name = "Android";}
      {name = "Configurations";}
      {name = "Et Cetera";}
    ];

  xdg.mimeApps.associations.added = {
    "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
    "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
  };

  xdg.configFile."paperwm/user.css".text = ''
    .paperwm-selection {
        border-radius: 12px 12px 0px 0px;
        background-color: rgba(0, 0, 0, 0);
    }
  '';

  home.packages = with pkgs;
  with gnome;
  with gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    caffeine
    dconf2nix
    dconf-editor
    gnome-tweaks
    gsconnect
    kimpanel
    neofetch
    pano
    paperwm
    phinger-cursors
    switcher
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
