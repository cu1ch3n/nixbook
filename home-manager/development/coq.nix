{pkgs, ...}: {
  home.packages = with pkgs;
  with coqPackages_8_19;
  with nur.repos.chen; [
    autosubst
    coq
    vscoq-language-server_2_2_1
    # lngen
    # metalib
    # ott-sweirich
    autosubst-ocaml
  ];

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.20/user-contrib";
  };
}
