{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
    mutableExtensionsDir = true;
    profiles.default.extensions =
      with pkgs.vscode-marketplace;
      [
        # akamud.vscode-theme-onedark
        # akamud.vscode-theme-onelight
        arrterian.nix-env-selector
        banacorn.agda-mode
        dracula-theme.theme-dracula
        maximedenes.vscoq
        # coq-community.vscoq1
        eamodio.gitlens
        github.copilot
        github.vscode-pull-request-github
        haskell.haskell
        james-yu.latex-workshop
        jnoortheen.nix-ide
        joeyeremondi.ott
        justusadam.language-haskell
        myriad-dreamin.tinymist
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
    profiles.default.userSettings = import ./user-settings.nix;
  };
}
