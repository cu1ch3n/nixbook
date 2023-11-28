{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "anmbbeeiaollmpadookgoakpfjkbidaf"; } # Volume Booster
      { id = "padekgcemlokbadohgkifijomclgjgif"; } # Proxy SwitchyOmega
    ];
  };
}
