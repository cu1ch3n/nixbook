{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  makeWrapper,
}:
let
  # Wrap the original package
  originalPackage = buildNpmPackage rec {
    pname = "claudecodeui";
    version = "1.15.0";

    src = fetchFromGitHub {
      owner = "siteboon";
      repo = "claudecodeui";
      rev = "v${version}";
      hash = "sha256-iTJK5jnHAEzcYAOXHqvMU+vReyWmqt2lgzZjV2Zjnb8=";
    };

    npmDepsHash = "sha256-DQ5jhXd7lCRXp3yfcjDyRywUeHrlDZ1m3wcbyvc4Jnw=";

    # Use Node.js 20 as required
    buildInputs = [ nodejs_20 ];

    # Build the application
    dontNpmBuild = false;

    meta = with lib; {
      description = "Use Claude Code, Cursor CLI or Codex on mobile and web with CloudCLI (aka Claude Code UI)";
      homepage = "https://github.com/siteboon/claudecodeui";
      license = licenses.gpl3Only;
      maintainers = [ ];
    };
  };
in
# Wrap the binaries to use a writable database path by default
originalPackage.overrideAttrs (oldAttrs: {
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];

  postInstall = ''
    # Create wrapper scripts that set a writable database path
    for bin in claude-code-ui cloudcli; do
      if [ -f "$out/bin/$bin" ]; then
        # Create a wrapper that sets the database path at runtime
        mv "$out/bin/$bin" "$out/bin/$bin.original"
        cat > "$out/bin/$bin" << 'WRAPPEREOF'
    #!/usr/bin/env bash
    BIN_NAME=$(basename "$0")
    # Set default database path if not already set
    if ! echo "$@" | grep -q -- "--database-path"; then
      DB_PATH="''${XDG_DATA_HOME:-$HOME/.local/share}/claudecodeui/auth.db"
      # Ensure directory exists
      mkdir -p "$(dirname "$DB_PATH")"
      exec "$(dirname "$0")/$BIN_NAME.original" --database-path "$DB_PATH" "$@"
    else
      exec "$(dirname "$0")/$BIN_NAME.original" "$@"
    fi
    WRAPPEREOF
            chmod +x "$out/bin/$bin"
          fi
        done
  '';
})
