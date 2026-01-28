{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/bluetooth"
      "/var/lib/fprint"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/waydroid"

      "/etc/NetworkManager/system-connections"
      "/etc/v2raya"
      "/etc/ngrok"
    ];

    files = [
      # "/etc/machine-id"
    ];

    users.chen = {
      directories = [
        # XDG user directories
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Public"
        "Templates"
        "Videos"

        # More directories
        "Configs"
        "Research"
        "Development"
        "VirtualMachines"

        ".config/1Password"
        ".config/cabal"
        ".config/chromium"
        ".config/Code"
        ".config/Cursor"
        ".config/discord"
        ".config/emacs"
        ".config/fcitx5"
        ".config/gh"
        ".config/Mullvad VPN"
        ".config/QQ"
        ".config/Slack"
        ".config/sublime-text/Local"
        ".config/yesplaymusic"
        ".config/qBittorrent"
        ".config/VirtualBox"
        ".local/share/keyrings"
        ".local/share/qBittorrent"
        ".local/share/Steam"
        ".local/share/Trash"
        ".local/share/waydroid"

        ".xwechat"
        ".ssh"
        ".stack"
        ".codex"
        ".secrets"
        ".clawdbot"
        ".opam"
      ];

      files = [
        ".zsh_history"
      ];
    };
  };

  environment.etc.machine-id.text = "67803336e24344e9aa58ea47b51180d0";

  programs.fuse.userAllowOther = true;
}
