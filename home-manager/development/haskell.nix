{ pkgs, ... }: {
  home.packages = with pkgs.haskellPackages; [
    ghc
    stack
    cabal-install
    haskell-language-server
  ];
}
