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
        enabled-extensions = [
          "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
          "paperwm@paperwm.github.com"
          "switcher@landau.fi"
        ];
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

      "org/gnome/shell/extensions/auto-move-windows" = {
        application-list = [
          "chromium-browser.desktop:1"
          "org.gnome.Nautilus.desktop:2"
          "qq.desktop:5"
          "discord.desktop:5"
          "spotify.desktop:6"
          "yesplaymusic.desktop:6"
          "Waydroid.desktop:7"
          "org.gnome.Extensions.desktop:8"
          "org.gnome.Settings.desktop:8"
        ];
      };

      "org/gnome/shell/extensions/switcher" = {
        workspace-indicator = true;
      };

      "org/gnome/shell/extensions/paperwm" = {
        horizontal-margin = 10;
        window-gap = 10;
        winprops = map toJSON [
          {
            "wm_class" = "1Password";
            "scratch_layer" = true;
          }
        ];
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

  # xdg.configFile."paperwm/user.css".text = ''
  #   .paperwm-selection {
  #       border-radius: 12px 12px 0px 0px;
  #       background-color: rgba(0, 0, 0, 0);
  #   }
  # '';

  home.packages = with pkgs;
  with gnome;
  with gnomeExtensions; [
    paperwm
    switcher
  ];
}
