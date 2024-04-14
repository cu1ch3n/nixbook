# This file defines overlays
{...}: {
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
            rev = "20ddea907e0b0c9c60d1dcb6b102bee38697cb5c";
            fetchSubmodules = false;
            sha256 = "sha256-kU3pceqQoIM4pypPg2nLLnnyrgQSUEWZW9VLmmPJltU=";
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
}
