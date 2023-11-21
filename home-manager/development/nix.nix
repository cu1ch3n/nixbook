{pkgs, ...}: {
  home.packages = with pkgs; [
    nixpkgs-fmt
    nixpkgs-review
    yarn2nix
  ];
}
