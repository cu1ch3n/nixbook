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
              rev = "main";
              sha256 = "sha256-ygalIDaJcp9jBoPeFtSFIMKMmZyCUj/XueyVhEIdUec=";
            }
          }/language-server";
        });
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
