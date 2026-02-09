{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "hapi";
  version = "0.15.1";

  src = fetchurl {
    url = "https://github.com/tiann/hapi/releases/download/v${version}/hapi-linux-x64.tar.gz";
    sha256 = "sha256-Q8tnvZwJ+9nqpjl79j1k7OKRYmpq2yRXyEd5jX6rm1A="; # Will be replaced by nix
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D hapi $out/bin/hapi
    runHook postInstall
  '';

  meta = with lib; {
    description = "App for Claude Code / Codex / Gemini / OpenCode, vibe coding anytime, anywhere";
    homepage = "https://github.com/tiann/hapi";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ chen ];
  };
}
