{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      # Default GitHub (routes via ssh.github.com:443)
      "github.com" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
      };

      # Bot identity for pushing as cu1ch3n-bot
      "github.com-bot" = {
        HostName = "ssh.github.com";
        Port = 443;
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_cu1ch3n_bot";
        IdentitiesOnly = true;
      };

      "*" = {
        IdentityAgent = "~/.1password/agent.sock";
      };
    };
  };
}
