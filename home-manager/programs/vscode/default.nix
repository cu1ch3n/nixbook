{ pkgs, ... }:
{
  programs.cursor = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-marketplace; [
      # akamud.vscode-theme-onedark
      # akamud.vscode-theme-onelight
      arrterian.nix-env-selector
      banacorn.agda-mode
      dracula-theme.theme-dracula
      rocq-prover.vsrocq
      # maximedenes.vscoq
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
    ];
    profiles.default.userSettings = import ./user-settings.nix;
  };
}
