{ pkgs, ... }: {
  home.packages = with pkgs; [
    nixpkgs-fmt
    nixpkgs-review
    rnix-lsp
    statix
    yarn
    yarn2nix
  ];
}
