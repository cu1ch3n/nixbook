{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        hostname = "github.com";
        port = 22;
        proxyCommand = "nc -x localhost:1089 %h %p";
      };
    };
  };
}
