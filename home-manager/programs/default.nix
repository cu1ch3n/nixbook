{
  imports = [
    ./codex
    ./emacs
    # ./firefox
    ./gnome
    ./kitty
    ./rime
    ./vscode
    ./alacritty.nix
    ./chromium.nix
    ./eyedropper.nix
    ./git.nix
    ./ssh.nix
    ./wps.nix
    ./zellij.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    vim.enable = true;
  };
}
