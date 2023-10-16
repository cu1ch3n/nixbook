{ pkgs, ... }:

{
  time.timeZone = "Asia/Hong_Kong";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    inputMethod = {
      enabled = "fcitx5";
      fcitx.engines = with pkgs.fcitx-engines; [ rime ];
      fcitx5.enableRimeData= true;
      fcitx5.addons = with pkgs; [ fcitx5-rime ];
    };
  };
}
