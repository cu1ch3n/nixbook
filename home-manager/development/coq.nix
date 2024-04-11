{ pkgs, ... }: {
  home.packages = with pkgs;
    with coqPackages_8_15;
    with nur.repos.chen; [
      coq
      lngen
      metalib
      ott-sweirich
    ];

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.15/user-contrib";
  };
}
