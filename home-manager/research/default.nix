{pkgs, ...}: let
  coqPkgs = with pkgs;
  with coqPackages_8_15; [
    coq
    lngen
    metalib
    ott
  ];
  abellaPkgs = with pkgs; [
    # abella
    abella-modded
  ];
in {
  home.packages = with pkgs;
    [
      texlive.combined.scheme-full
    ]
    ++ coqPkgs
    ++ abellaPkgs;

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.15/user-contrib";
  };
}
