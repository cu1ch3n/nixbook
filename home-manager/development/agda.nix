{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (agda.withPackages (pkgs: with pkgs; [ standard-library ]))
  ];
}
