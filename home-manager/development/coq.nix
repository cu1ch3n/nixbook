{pkgs, ...}: {
  home.packages = with pkgs;
  with coqPackages_8_19;
  with nur.repos.chen; [
    autosubst
    master.coqPackages_8_19.autosubst-ocaml
    coq
    # vscoq-language-server_2_2_1
    # lngen
    # metalib
    # ott-sweirich
    # vampire
    # cvc4
    # eprover
    # z3-tptp
    coq-hammer
    coq-hammer-tactics
  ];

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.19/user-contrib";
  };
}
