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
        # "https://coq.cachix.org"
        # "https://coq-community.cachix.org"
        # "https://math-comp.cachix.org"
        # "https://cache.iog.io"
      ];
      extra-trusted-public-keys = [
        "chen.cachix.org-1:QzFtWpjuwQylPYCuX7k6m6anRVi/e658FfWZRcTnRgs="
        # "coq.cachix.org-1:5QW/wwEnD+l2jvN6QRbRRsa4hBHG3QiQQ26cxu1F5tI="
        # "coq-community.cachix.org-1:WBDHojv8FM6nI4ZMh43X+2g6j4WpAn+dFhjhWmLCgnA="
        # "math-comp.cachix.org-1:ZoAy3dSWncrBPpEsNHa1Rbio0Oly3TFrZXlVTdofbQU="
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
