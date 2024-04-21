{pkgs, ...}: {
  imports = [
    ./homepage
  ];

  environment.systemPackages = with pkgs; [
    netavark
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.oci-containers.backend = "podman";
  virtualisation.containers.containersConf.settings = {
    engine = {
      helper_binaries_dir = ["/run/current-system/sw/bin"];
    };
  };
}
