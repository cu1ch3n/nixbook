{pkgs, ...}: {
  home.packages = with pkgs; [
    coq_8_15
    coqPackages.metalib
    ott
  ];
}
