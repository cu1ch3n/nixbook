{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-marketplace; [
      akamud.vscode-theme-onedark
      akamud.vscode-theme-onelight
      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github
      eamodio.gitlens
      haskell.haskell
      justusadam.language-haskell
      jnoortheen.nix-ide
      coq-community.vscoq1
    ];
  };
}
