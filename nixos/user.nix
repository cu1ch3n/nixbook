{pkgs, ...}: {
  users.users.chen = {
    initialPassword = "init_passwd";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "audio" "docker" "networkmanager"];
  };

  programs.zsh.enable = true;
}
