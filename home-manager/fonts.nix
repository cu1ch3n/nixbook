{ pkgs, ... }:

{
  home.packages = with pkgs; [
    font-manager
    fira
    fira-code
    fira-code-symbols
    font-awesome
    nerdfonts
    source-code-pro
    wqy_microhei
    wqy_zenhei
  ];

  fonts.fontconfig.enable = true;
}
