{
  virtualisation.oci-containers.containers.homepage = {
    image = "ghcr.io/gethomepage/homepage:latest";
    ports = [ "127.0.0.1:8000:3000"];
    volumes = [
      "${./config}:/app/config"
    ];
  };
}
