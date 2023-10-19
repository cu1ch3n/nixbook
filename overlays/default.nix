# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    abella-modded = prev.abella.overrideAttrs (oldAttrs: {
      pname = "abella-modded";
      version = "c64dad1";
      src = prev.fetchFromGitHub {
        owner = "JimmyZJX";
        repo = "abella";
        rev = "c64dad15e2351433ab11fb716347fe54a8fec11e";
        hash = "sha256-z7oO7pqjZEcZY2+W1T/T6GpY3eqRuTq5lVf7eLit5VU=";
      };
    });
  };
}
