{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Roboto Mono"
          "WenQuanYi Micro Hei Mono"
          "Source Han Mono SC"
        ];
        sansSerif = [
          "Roboto"
          "WenQuanYi Micro Hei"
          "Source Han Sans SC"
        ];
        serif = [
          "Roboto Serif"
          "WenQuanYi Zen Hei Sharp"
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
      roboto-mono
      roboto-serif
      sarasa-gothic
      source-han-mono
      source-han-sans
      source-han-serif
      wqy_microhei
      wqy_zenhei
    ];
  };
}
