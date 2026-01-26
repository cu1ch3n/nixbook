{
  pkgs,
  ...
}:
{
  programs.clawdbot = {
    documents = ./documents;
    instances.default = {
      enable = true;
      package = pkgs.clawdbot;
      stateDir = "~/.clawdbot";
      workspaceDir = "~/.clawdbot/workspace";

      providers.telegram = {
        enable = true;
        botTokenFile = "~/.secrets/telegram-bot-token";
        allowFrom = [
          7462364379
        ];
      };

      systemd.enable = true;
    };
  };
}
