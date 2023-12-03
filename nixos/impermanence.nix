{ inputs
, ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
}
