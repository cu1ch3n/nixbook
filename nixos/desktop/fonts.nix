{pkgs, ...}: {
  hardware.video.hidpi.enable = false;

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Source Han Mono SC"
        ];
        sansSerif = [
          "Source Han Sans SC"
        ];
        serif = [
          "Source Han Serif SC"
        ];
      };
      hinting = {
        enable = true;
        style = "full";
        autohint = true;
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      hack-font
      inter
      liberation_ttf
      noto-fonts-color-emoji
      roboto
      sarasa-gothic
      source-han-mono
      source-han-sans
      source-han-serif
      wqy_microhei
      wqy_zenhei
    ];
  };
}
