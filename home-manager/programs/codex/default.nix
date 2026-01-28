{
  pkgs,
  config,
  ...
}:
{
  programs.codex = {
    enable = true;
    package = pkgs.codex;
  };

  home.file.".local/bin/vsrocqtop" = {
    executable = true;
    source = "${pkgs.vsrocq-language-server-mcp}/bin/vsrocqtop";
  };
}
