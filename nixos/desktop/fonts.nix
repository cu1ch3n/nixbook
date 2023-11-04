{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "JetBrains Mono"
          "Source Han Mono SC"
        ];
        sansSerif = [
          "Inter"
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
      fira
      fira-mono
      fira-code
      hack-font
      inter
      iosevka
      jetbrains-mono
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
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
