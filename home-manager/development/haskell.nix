{pkgs, ...}: {
  home.packages = with pkgs; [
    haskellPackages.stack
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server
  ];
}
