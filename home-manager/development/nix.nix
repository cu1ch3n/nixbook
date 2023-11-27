{ pkgs, ... }: {
  home.packages = with pkgs; [
    deadnix
    nixpkgs-fmt
    nixpkgs-review
    nil
    statix
    yarn
    yarn2nix
  ];
}
