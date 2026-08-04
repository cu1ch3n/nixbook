{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "hapi";
  version = "0.26.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@twsxtd/hapi-linux-x64/-/hapi-linux-x64-${version}.tgz";
    hash = "sha512-m1uNUb2dsBSa4S+P39+4kf0e8qJgYEZqkaDOGLNJ5RsJIkQqfemPRij6Li+K5xgxtN3nME23/aLuhtn5wmCEgQ==";
  };

  sourceRoot = "package";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -m755 -D bin/hapi $out/bin/hapi
    runHook postInstall
  '';

  meta = with lib; {
    description = "App for Claude Code / Codex / Gemini / OpenCode, vibe coding anytime, anywhere";
    homepage = "https://github.com/tiann/hapi";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ chen ];
  };
}
