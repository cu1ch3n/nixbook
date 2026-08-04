# This file defines overlays
{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = _final: prev: {
    # Codex releases very frequently. Track it from nixpkgs master without
    # changing the default nixpkgs source used by the rest of the system.
    codex = inputs.nixpkgs-master.legacyPackages.${prev.stdenv.hostPlatform.system}.codex;

    # Codex uses the current HEAD of this fork as a Rocq MCP server.
    vsrocq-language-server-mcp = prev.rocqPackages_9_1.vsrocq-language-server.overrideAttrs (_: {
      version = "mcp";
      src = "${
        prev.fetchFromGitHub {
          owner = "cu1ch3n";
          repo = "vsrocq-mcp";
          rev = "98c417ade081abf53c204f79645fefb8b26df4b6";
          hash = "sha256-ygalIDaJcp9jBoPeFtSFIMKMmZyCUj/XueyVhEIdUec=";
        }
      }/language-server";
    });
  };

}
