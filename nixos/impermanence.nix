{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/mullvad-vpn"
      "/etc/NetworkManager/system-connections"
      "/etc/v2raya"

      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/fprint"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/waydroid"
    ];

    files = [
      "/etc/machine-id"
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
        ".config/chromium"
        ".config/Code"
        ".config/Cursor"
        ".config/discord"
        ".config/emacs"
        ".config/fcitx5"
        ".config/gh"
        ".config/inkscape"
        ".config/Kingsoft"
        ".config/Mullvad VPN"
        ".config/obsidian"
        ".config/opencode"
        ".config/QQ"
        ".config/Slack"
        ".config/Snipaste"
        ".config/spotify"
        ".config/strawberry"
        ".config/sublime-merge"
        ".config/vlc"
        ".config/qBittorrent"
        ".config/VirtualBox"
        ".local/share/fcitx5"
        ".local/share/Kingsoft"
        ".local/share/keyrings"
        ".local/share/okular"
        ".local/share/opencode"
        ".local/share/qBittorrent"
        ".local/share/Steam"
        ".local/share/strawberry"
        ".local/share/TelegramDesktop"
        ".local/share/Trash"
        ".local/share/waydroid"
        ".local/state/opencode"

        ".cabal"
        ".cursor"
        ".mozilla"
        ".wine"
        ".xwechat"
        ".zoom"
        ".zotero"
        ".ssh"
        ".stack"
        ".codex"
        ".secrets"
        ".opam"
        ".hapi"
        "Zotero"
      ];

      files = [
        ".config/okularrc"
        ".config/zoomus.conf"
        ".zsh_history"
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
