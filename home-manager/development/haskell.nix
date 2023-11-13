{pkgs, ...}: {
  home.packages = with pkgs.haskellPackages; [
    stack
    cabal-install
    haskell-language-server
  ];
}
