# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: {
  marvin = pkgs.callPackage ./marvin.nix {};
  quartz = pkgs.callPackage ./quartz.nix {};
}
