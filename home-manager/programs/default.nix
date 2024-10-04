{
  imports = [
    ./emacs
    # ./firefox
    ./gnome
    ./rime
    ./vscode
    ./wechat
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
