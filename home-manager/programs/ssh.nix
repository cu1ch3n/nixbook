{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      # Default GitHub (routes via ssh.github.com:443)
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };

      # # Bot identity for pushing as cu1ch3n-bot
      # "github.com-bot" = {
      #   hostname = "ssh.github.com";
      #   port = 443;
      #   user = "git";
      #   identityFile = "~/.ssh/id_ed25519_cu1ch3n_bot";
      #   extraOptions.IdentitiesOnly = "yes";
      # };

      # "*" = {
      #   extraOptions.IdentityAgent = "~/.1password/agent.sock";
      # };
    };
  };
}
