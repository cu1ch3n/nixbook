# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, ... }:
{
  quartz = pkgs.callPackage ./quartz.nix { };
  hapi = pkgs.callPackage ./hapi.nix { };
}
