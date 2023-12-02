{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace;
      [
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
      ]
      ++ (with pkgs.vscode-extensions; [
        github.vscode-pull-request-github
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "copilot-chat";
          publisher = "github";
          version = "0.10.2";
          sha256 = "NfVg0Mor6agPrPYuzsNiWgX5DAcSysWaP3GilyXv/S4=";
        }
      ];
    userSettings = import ./user-settings.nix;
  };

  # home.sessionVariables = {
  #   NIXOS_OZONE_WL = "1"; # for wayland
  # };
}
