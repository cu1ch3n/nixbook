{
  pkgs,
  ...
}: {
  users.users = {
    root = {
      # inherit initialHashedPassword;
      hashedPasswordFile = "/persist/passwordFiles/root";
    };

    chen = {
      # inherit initialHashedPassword;
      hashedPasswordFile = "/persist/passwordFiles/chen";
      description = "Chen";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "audio" "docker" "networkmanager"];
    };
  };

  programs.zsh.enable = true;

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
