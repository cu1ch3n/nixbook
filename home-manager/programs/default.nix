{
  imports = [
    ./firefox
    ./rime
    ./vscode
    ./alacritty.nix
    ./chromium.nix
    ./git.nix
    ./ssh.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };
}
