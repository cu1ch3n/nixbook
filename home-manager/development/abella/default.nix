{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    with nur.repos.chen;
    [
      abella-master
      abella-modded
    ];
}
