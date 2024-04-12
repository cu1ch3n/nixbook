{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace; [
      akamud.vscode-theme-onedark
      akamud.vscode-theme-onelight
      github.copilot
      eamodio.gitlens
      haskell.haskell
      justusadam.language-haskell
      yellpika.latex-input
      jnoortheen.nix-ide
      richie5um2.vscode-sort-json
      vscode-icons-team.vscode-icons
      coq-community.vscoq1
      github.vscode-pull-request-github
      github.copilot-chat
    ];
    userSettings = import ./user-settings.nix;
  };
}
