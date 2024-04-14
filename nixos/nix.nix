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
      ];
      extra-trusted-public-keys = [
        "chen.cachix.org-1:QzFtWpjuwQylPYCuX7k6m6anRVi/e658FfWZRcTnRgs="
      ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
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
