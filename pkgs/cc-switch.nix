{
  lib,
  fetchurl,
  appimageTools,
}:
let
  pname = "cc-switch";
  version = "3.10.3";
  src = fetchurl {
    url = "https://github.com/farion1231/cc-switch/releases/download/v${version}/CC-Switch-v${version}-Linux-x86_64.AppImage";
    name = "CC-Switch-${version}.AppImage";
    sha256 = "sha256-jxLumycq+PhdaKJv6HiwvwfumE13+6/gkTjbUPVWLAw=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  extraInstallCommands = ''
    install -m 444 -D "${appimageContents}/CC Switch.desktop" "$out/share/applications/CC Switch.desktop"
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256@2/apps/cc-switch.png \
      $out/share/icons/hicolor/256x256@2/apps/cc-switch.png
    substituteInPlace "$out/share/applications/CC Switch.desktop" \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A cross-platform desktop All-in-One assistant tool for Claude Code, Codex, OpenCode & Gemini CLI.";
    homepage = "https://github.com/farion1231/cc-switch";
    license = licenses.mit;
    maintainers = with maintainers; [ chen ];
    platforms = [ "x86_64-linux" ];
  };
}

