{pkgs, ...}: {
  home.packages = with pkgs;
  with coqPackages_8_20;
  with nur.repos.chen; [
    autosubst
    autosubst2
    coq
    vscoq-language-server_2_2_1
    # lngen
    # metalib
    # ott-sweirich
  ];

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.20/user-contrib";
  };
}
