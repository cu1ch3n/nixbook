{ pkgs, ... }:
let
  initialHashedPassword = "$6$ai4g3AoqwV/Dq3Jt$nrSP41V/xZY5K5oEbr2s1JxJ3chXaXQX1LVDsn6QGlDAIiikb0/K9pi0jPgYJyu0dTuGjDQre8mY7SO9sSLXT1";
in
{
  # sudo mkdir -p /nix/persist/passwordFiles/
  # sudo nix-shell --run 'mkpasswd -m SHA-512 -s > /nix/persist/passwordFiles/chen' -p mkpasswd
  users.users = {
    root = {
      inherit initialHashedPassword;
      hashedPasswordFile = "/nix/persist/passwordFiles/root";
    };

    chen = {
      inherit initialHashedPassword;
      hashedPasswordFile = "/nix/persist/passwordFiles/chen";
      description = "Chen";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "audio" "docker" "networkmanager" ];
      packages = with pkgs; [
        # protontricks
      ];
    };
  };

  programs.zsh.enable = true;

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };
}
