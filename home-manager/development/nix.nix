{ pkgs, ... }: {
  home.packages = with pkgs; [
    comma
    deadnix
    nixd
    nix-init
    nixpkgs-fmt
    nixpkgs-review
    statix
    yarn
    yarn2nix
  ];
}
