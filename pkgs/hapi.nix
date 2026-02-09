{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "hapi";
  version = "0.15.1";

  # Use pre-built binary from GitHub releases
  src = fetchurl {
    url = "https://github.com/tiann/hapi/releases/download/v${version}/hapi-linux-x64.tar.gz";
    hash = "sha256-Q8tnvZwJ+9nqpjl79j1k7OKRYmpq2yRXyEd5jX6rm1A=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  # No build phase needed - just extract and install
  dontBuild = true;
  dontUnpack = false;

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $out
    tar -xzf $src -C $out
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    
    # The binary should be in the extracted directory
    if [ -f $out/hapi ]; then
      mv $out/hapi $out/bin/hapi
      chmod +x $out/bin/hapi
    elif [ -d $out/hapi-linux-x64 ] && [ -f $out/hapi-linux-x64/hapi ]; then
      mv $out/hapi-linux-x64/hapi $out/bin/hapi
      chmod +x $out/bin/hapi
      rm -rf $out/hapi-linux-x64
    else
      # Try to find the binary in the extracted directory
      BINARY=$(find $out -name "hapi" -type f | head -1)
      if [ -n "$BINARY" ]; then
        mv "$BINARY" $out/bin/hapi
        chmod +x $out/bin/hapi
      else
        echo "Error: hapi binary not found in extracted archive"
        ls -la $out
        exit 1
      fi
    fi
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Run official Claude Code / Codex / Gemini / OpenCode sessions locally and control them remotely through a Web / PWA / Telegram Mini App";
    homepage = "https://github.com/tiann/hapi";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
