{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace; [
      akamud.vscode-theme-onedark
      akamud.vscode-theme-onelight
      coq-community.vscoq1
      eamodio.gitlens
      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github
      haskell.haskell
      jnoortheen.nix-ide
      justusadam.language-haskell
      richie5um2.vscode-sort-json
      skellock.just
      vscode-icons-team.vscode-icons
      yellpika.latex-input
    ];
    userSettings = import ./user-settings.nix;
  };
}
