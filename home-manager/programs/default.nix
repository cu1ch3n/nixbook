{
  imports = [
    # ./firefox
    ./gnome
    ./rime
    ./vscode
    ./alacritty.nix
    ./chromium.nix
    ./eyedropper.nix
    ./git.nix
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
