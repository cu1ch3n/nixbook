{pkgs, ...}: {
  home.packages = with pkgs; [
    typst
    typst-preview
    typst-lsp
  ];
}
