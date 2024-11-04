# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  modifications = final: prev: {
    vscoq-language-server_2_2_1 = prev.coqPackages_8_20.vscoq-language-server.overrideAttrs (oldAttrs: rec {
      version = "2.2.1";
      src = "${prev.fetchFromGitHub {
        owner = "coq-community";
        repo = "vscoq";
        rev = "v${version}";
        sha256 = "sha256-miIVAv/8jlP1pXnoK1MWz4O6nlmb309a8UjcCivbiB4=";
      }}/language-server";
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
