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
    url = "https://registry.npmjs.org/@twsxtd/hapi-linux-x64/-/hapi-linux-x64-${version}.tgz";
    hash = "sha512-FCsISQ5ucoV7Oi16J48OJxsVYmwmJ8MSHDrH0JXU4nEzXwGzryfHcEBdExnaT/WWERFtLZhxoIUxK2EetDjLYA==";
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
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ chen ];
  };
}
