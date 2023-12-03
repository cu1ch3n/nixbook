# This file defines overlays
{ ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  modifications = final: prev: {
    librime-lua = (prev.librime.override {
      plugins = [
        (prev.fetchFromGitHub {
          owner = "hchunhui";
          repo = "librime-lua";
          rev = "7c297e4d2e08fcdd3e9b2dcae2a42317b9a217ff";
          sha256 = "sha256-GVfr2fzaQYyfNnjN20YcNfBVB144gZKVEunbX10Mgeg=";
        })
      ];
    }).overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ prev.luajit ];
    });

    fcitx5-rime-lua = prev.fcitx5-rime.overrideAttrs (old: {
      buildInputs = [ prev.fcitx5 final.librime-lua ];
    });
  };
}
