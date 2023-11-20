{pkgs, ...}: {
  users.users.chen = {
    description = "Chen";
    initialPassword = "init_passwd";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "audio" "docker" "networkmanager"];
    packages = with pkgs; [
      # protontricks
    ];
  };

  programs.zsh.enable = true;

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  # };
}
