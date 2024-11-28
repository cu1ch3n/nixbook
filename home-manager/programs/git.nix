{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Chen";
    userEmail = "i@cuichen.cc";
    extraConfig = {
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAikGltB46LIhsjvVIa2X8iP2do5CnpVXJojvfGiYsmW";
      gpg = {
        format = "ssh";
        "ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      commit.gpgsign = true;
    };
  };
}
