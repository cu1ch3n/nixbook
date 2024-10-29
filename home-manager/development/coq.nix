{pkgs, ...}: {
  home.packages = with pkgs;
  with coqPackages_8_20;
  with nur.repos.chen; [
    autosubst
    coq
    # lngen
    # metalib
    # ott-sweirich
  ];

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.20/user-contrib";
  };
}
