{
  imports = [
    ./bookmarks.nix
    ./widgets.nix
  ];

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8114;

    settings = {
      title = "Homepage Dashboard";
      color = "neutral";
    };
  };
}
