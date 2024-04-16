{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];
  environment.systemPackages = [inputs.agenix.packages.x86_64-linux.default];

  age.identityPaths = ["/home/chen/.ssh/id_ed25519"];

  age.secrets.rootHashedPasswordFile = {
    file = ./rootHashedPasswordFile.age;
    mode = "400";
    owner = "root";
    group = "root";
  };

  age.secrets.chenHashedPasswordFile = {
    file = ./chenHashedPasswordFile.age;
    mode = "400";
    owner = "root";
    group = "root";
  };
}
