{
  imports = [
    # ./firefox
    ./gnome
    # ./hyprland
    ./rime
    ./vscode
    ./alacritty.nix
    ./chromium.nix
    ./eyedropper.nix
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
