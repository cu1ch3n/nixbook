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

        { directory = ".ssh"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
      ];
    };
  };

  programs.fuse.userAllowOther = true;
}
