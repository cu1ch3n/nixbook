# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  modifications = final: prev: {
    librime-lua =
      (prev.librime.override {
        plugins = [
          (prev.fetchFromGitHub {
            owner = "hchunhui";
            repo = "librime-lua";
            rev = "7c1b93965962b7c480d4d7f1a947e4712a9f0c5f";
            fetchSubmodules = false;
            sha256 = "sha256-H/ufyHIfYjAjF/Dt3CilL4x9uAXGcF1BkdAgzIbSGA8==";
          })
        ];
      })
      .overrideAttrs (old: {
        buildInputs = (old.buildInputs or []) ++ [prev.luajit];
      });

    fcitx5-rime-lua = prev.fcitx5-rime.overrideAttrs (_: {
      buildInputs = [prev.fcitx5 final.librime-lua];
    });
  };

  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
