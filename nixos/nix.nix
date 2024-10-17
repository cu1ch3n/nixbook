{
  inputs,
  lib,
  config,
  ...
}: {
  nix = {
    settings = {
      extra-substituters = [
        "https://chen.cachix.org"
        # "https://cache.iog.io"
      ];
      extra-trusted-public-keys = [
        "chen.cachix.org-1:QzFtWpjuwQylPYCuX7k6m6anRVi/e658FfWZRcTnRgs="
        # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +3";
    };

    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };
}
