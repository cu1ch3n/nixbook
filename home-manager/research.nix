{pkgs, ...}: {
  home.packages = with pkgs;
  with coqPackages_8_15; [
    coq
    metalib
    ott
    lngen
  ];

  home.sessionVariables = {
    COQPATH = "$HOME/.nix-profile/lib/coq/8.15/user-contrib";
  };
}
