{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    fd
    ripgrep
    multimarkdown
    shellcheck
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  services.emacs.enable = true;
  xdg.configFile."emacs/doom".source = ./doom;

  home.sessionPath = ["${config.xdg.configHome}/emacs/bin"];
}
