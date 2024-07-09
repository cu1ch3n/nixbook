{pkgs, ...}: {
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    python3Packages.pygments
  ];
}
