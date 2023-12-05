{ inputs
, config
, lib
, ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/nix/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"

      "/etc/NetworkManager/system-connections"
      "/etc/v2raya"
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

        { directory = ".config/1Password"; mode = "0700"; }
        ".config/chromium"
        ".config/Code"
        { directory = ".config/Slack"; mode = "0700"; }

        { directory = ".local/share/keyrings"; mode = "0700"; }
        { directory = ".ssh"; mode = "0700"; }
      ];

      files = [
        ".zsh_history"
      ];
    };
  };

  environment.etc.machine-id.text = "67803336e24344e9aa58ea47b51180d0";

  programs.fuse.userAllowOther = true;
}