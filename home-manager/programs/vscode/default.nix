{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-marketplace; [
      akamud.vscode-theme-onedark
      akamud.vscode-theme-onelight
      github.copilot
      eamodio.gitlens
      haskell.haskell
      justusadam.language-haskell
      jnoortheen.nix-ide
      richie5um2.vscode-sort-json
      vscode-icons-team.vscode-icons
      coq-community.vscoq1
    ] ++ (with pkgs.vscode-extensions; [
      github.copilot-chat
      github.vscode-pull-request-github
    ]);
    userSettings = import ./user-settings.nix;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # for wayland
  };
}
