{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
  ];

  programs._1password-gui.enable = true;
  programs._1password.enable = true;

  # age.identityPaths = ["/home/chen/.ssh/id_ed25519.pub"];
  # Stop using age before it's ready to support SSH agent
}
