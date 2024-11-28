{ pkgs, ... }:
{
  time.timeZone = "Asia/Hong_Kong";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk
      ];
    };
  };
}
