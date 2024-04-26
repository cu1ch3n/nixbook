{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      bind_port = 8888;
      http.address = "127.0.0.1:8888";
      
      dns = {
        ratelimit = 0;
        bind_host = "127.0.0.1";
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];
        upstream_dns = [
          "1.1.1.1"
          "1.0.0.1"
          "8.8.8.8"
          "8.8.4.4"
        ];
      };
    };
  };

  networking.nameservers = ["127.0.0.1"];
}
