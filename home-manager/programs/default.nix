{
  imports = [
    ./git.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    tmux.enable = true;
    vim.enable = true;
    eza = {
      enable = true;
      enableAliases = true;
    };
    vscode.enable = true;
  };
}
