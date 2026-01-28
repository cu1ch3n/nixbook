# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  modifications = final: prev: {
    # vsrocq-mcp: fork of vsrocq with MCP support
    # Note: When building, nix will error with the correct sha256 hash if this is wrong
    vsrocq-language-server-mcp =
      prev.rocqPackages_9_1.vsrocq-language-server.overrideAttrs
        (oldAttrs: {
          version = "mcp";
          src = "${
            prev.fetchFromGitHub {
              owner = "cu1ch3n";
              repo = "vsrocq-mcp";
              rev = "98c417ade081abf53c204f79645fefb8b26df4b6";
              sha256 = "sha256-ygalIDaJcp9jBoPeFtSFIMKMmZyCUj/XueyVhEIdUec=";
            }
          }/language-server";
        });

    # happy-coder: use GitHub source instead of nixpkgs version
    # Note: When building, nix will error with the correct sha256 hash if this is wrong
    # happy-coder = prev.happy-coder.overrideAttrs (oldAttrs: let
    #   src = prev.fetchFromGitHub {
    #     owner = "slopus";
    #     repo = "happy";
    #     rev = "e9f85c7ebc6ae29d3aefcb460bffa83c5e30632b";
    #     sha256 = "sha256-8MiJhUDvL6sSx1r2IrHcZ5VswD52lK1chiZWrn6Ik0k=";
    #   };
    # in {
    #   version = "main";
    #   inherit src;
    #   # Recalculate yarnOfflineCache from the new source
    #   yarnOfflineCache = prev.fetchYarnDeps {
    #     yarnLock = "${src}/yarn.lock";
    #     hash = "sha256-epPfWp8DjKT8egdWdYNFZaiaCXDzSVpx2bQNXJdoBVY=";
    #   };
    # });
  };

  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
