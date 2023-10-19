{
  imports = [
    ./rime
    ./alacritty.nix
    ./chromium.nix
    ./git.nix
    ./virt-manager.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    tmux.enable = true;
    vim.enable = true;
    vscode.enable = true;
  };
}
