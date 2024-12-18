{
  imports = [
    ./emacs
    # ./firefox
    ./gnome
    ./hyprland
    ./rime
    ./vscode
    ./waybar
    ./wofi
    ./alacritty.nix
    ./chromium.nix
    ./eyedropper.nix
    ./git.nix
    ./plasma
    ./ssh.nix
    ./wps.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };
}
