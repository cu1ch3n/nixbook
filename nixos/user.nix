{ pkgs, ... }:
let
  initialHashedPassword = "$6$ai4g3AoqwV/Dq3Jt$nrSP41V/xZY5K5oEbr2s1JxJ3chXaXQX1LVDsn6QGlDAIiikb0/K9pi0jPgYJyu0dTuGjDQre8mY7SO9sSLXT1";
in
{
  users.users.root = { inherit initialHashedPassword; };
  users.users.chen = {
    inherit initialHashedPassword;
    description = "Chen";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "docker" "networkmanager" ];
    packages = with pkgs; [
      # protontricks
    ];
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
