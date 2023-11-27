{ pkgs, ... }: {
  home.packages = with pkgs; [
    deadnix
    nixpkgs-fmt
    nixpkgs-review
    rnix-lsp
    statix
    yarn
    yarn2nix
  ];
}
