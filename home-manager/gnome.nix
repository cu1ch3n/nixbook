{pkgs, ...}: {
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "chromium.desktop"
        "code.desktop"
        "org.gnome.Terminal.desktop"
      ];

      enabled-extensions = [
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    appindicator
  ];
}
