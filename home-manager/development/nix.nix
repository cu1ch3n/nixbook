{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    comma
    deadnix
    nil
    nix-init
    nix-output-monitor
    nixfmt-rfc-style
    nixpkgs-fmt
    nixpkgs-review
    statix
    yarn
    yarn2nix
  ];
}
