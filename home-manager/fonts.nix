{ pkgs, ... }:

{
  home.packages = with pkgs; [
    font-manager
    fira
    fira-code
    fira-code-symbols
    font-awesome
    hack-font
    jetbrains-mono
    nerdfonts
    noto-fonts
    source-code-pro
    source-han-sans
    source-han-serif
    wqy_microhei
    wqy_zenhei
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Noto Sans Mono CJK SC"
        "Sarasa Mono SC"
        "DejaVu Sans Mono"
      ];
      sansSerif = [
        "Noto Sans CJK SC"
        "Source Han Sans SC"
        "DejaVu Sans"
      ];
      serif = [
        "Noto Serif CJK SC"
        "Source Han Serif SC"
        "DejaVu Serif"
      ];
    };
  };
}
