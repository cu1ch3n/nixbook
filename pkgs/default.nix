# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: rec {
  agda-language-server = pkgs.callPackage ./agda-language-server.nix { lsp = lsp_1_6_0_0; Agda = Agda_2_6_4; };
  lsp_1_6_0_0 = pkgs.haskellPackages.callHackage "lsp" "1.6.0.0" { lsp-types = lsp-types_1_6_0_0; sorted-list = sorted-list_0_2_1_2; };
  lsp-types_1_6_0_0 = pkgs.haskellPackages.callHackage "lsp-types" "1.6.0.0" {};
  sorted-list_0_2_1_2 = pkgs.haskellPackages.callHackage "sorted-list" "0.2.1.2" {};
  Agda_2_6_4 = (pkgs.haskellPackages.callHackage "Agda" "2.6.4" {}).overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs or [] ++ [ pkgs.agdaPackages.standard-library ];
  });
  abella-master = pkgs.callPackage ./abella-master {};
  autosubst2 = pkgs.callPackage ./autosubst2.nix {};

  marvin = pkgs.callPackage ./marvin.nix {};
  quartz = pkgs.callPackage ./quartz.nix {};
}
