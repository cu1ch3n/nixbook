{ pkgs, ... }:
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
    ghostty.enable = true;
    home-manager.enable = true;
    opencode.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };

  # GNOME's application monitor does not follow Home Manager's profile
  # symlink when it changes. Keep the launcher in the stable XDG data path.
  xdg.dataFile."applications/com.mitchellh.ghostty.desktop".source =
    "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop";
}
