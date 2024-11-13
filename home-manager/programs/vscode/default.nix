{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace;
      [
        # akamud.vscode-theme-onedark
        # akamud.vscode-theme-onelight
        banacorn.agda-mode
        # maximedenes.vscoq
        coq-community.vscoq1
        eamodio.gitlens
        github.copilot
        github.vscode-pull-request-github
        haskell.haskell
        james-yu.latex-workshop
        jnoortheen.nix-ide
        justusadam.language-haskell
        myriad-dreamin.tinymist
        nvarner.typst-lsp
        richie5um2.vscode-sort-json
        skellock.just
        teabyii.ayu
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
    userSettings = import ./user-settings.nix;
  };
}
