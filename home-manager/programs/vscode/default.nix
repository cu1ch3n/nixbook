{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace;
      [
        akamud.vscode-theme-onedark
        akamud.vscode-theme-onelight
        coq-community.vscoq1
        eamodio.gitlens
        github.copilot
        github.vscode-pull-request-github
        haskell.haskell
        jnoortheen.nix-ide
        justusadam.language-haskell
        mgt19937.typst-preview
        nvarner.typst-lsp
        richie5um2.vscode-sort-json
        skellock.just
        vscode-icons-team.vscode-icons
        yellpika.latex-input
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "copilot-chat";
          publisher = "github";
          version = "0.14.1";
          sha256 = "d5oohDNF44+3FRYOIAv32hSgFvvggugDP+kbOAcYfX0=";
        }
      ];
    userSettings = import ./user-settings.nix {inherit pkgs;};
  };
}
