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

    firstParty = {
      summarize.enable = false; # Summarize web pages, PDFs, videos
      peekaboo.enable = false; # Take screenshots
      oracle.enable = false; # Web search
      poltergeist.enable = false; # Control your macOS UI
      sag.enable = false; # Text-to-speech
      camsnap.enable = false; # Camera snapshots
      gogcli.enable = false; # Google Calendar
      bird.enable = false; # Twitter/X
      sonoscli.enable = false; # Sonos control
      imsg.enable = false; # iMessage
    };
  };
}
