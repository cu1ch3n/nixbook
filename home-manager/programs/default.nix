{
  imports = [
    ./chromium.nix
    ./git.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    tmux.enable = true;
    vim.enable = true;
    vscode.enable = true;
  };
}
