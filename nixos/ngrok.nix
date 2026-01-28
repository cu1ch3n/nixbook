{ pkgs, lib, ... }:
{
  services.ngrok = {
    enable = true;
    # In ngrok v3, authtoken must be nested under the 'agent' field
    # See: https://ngrok.com/docs/agent/config/v3
    extraConfig = {
      version = "3";
      agent = {
        authtoken = "38tEEVIzcmaDdT8F2v5J3vbwNJo_4YYTZ9nfUwviQ36rqkWDk";
        # api_key is optional - only needed if you use 'ngrok api' commands
        # api_key = "your-api-key-here";
      };
    };
    tunnels = {
      # SSH tunnel - allows remote SSH access to your laptop
      ssh = {
        proto = "tcp";
        addr = 22; # SSH port
        # Note: TCP tunnels don't support custom domains in free tier
        # You'll get a random ngrok.io address assigned
      };
      # Optional: Add more tunnels for other services
      # web = {
      #   proto = "http";
      #   addr = 8080;
      #   # domain = "your-web-app.ngrok.io";
      # };
    };
  };

  # Set shell for ngrok user to disable login (required when mutableUsers = false)
  # Use mkForce to override the null value set by the ngrok module
  users.users.ngrok = {
    shell = lib.mkForce pkgs.shadow;
  };
}
