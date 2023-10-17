{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium-browser.desktop"
        "code.desktop"
        "Alacritty.desktop"
        "slack.desktop"
        "clash-verge.desktop"
      ];

      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "pop-shell@system76.com"
      ];
    };
    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
  };

  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    pop-shell
    vitals
  ];
}
