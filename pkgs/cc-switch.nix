{
  lib,
  fetchurl,
  appimageTools,
}:
let
  pname = "cc-switch";
  version = "3.10.3";
  name = "CC-Switch-${version}";
  src = fetchurl {
    url = "https://github.com/farion1231/cc-switch/releases/download/v${version}/CC-Switch-v${version}-Linux-x86_64.AppImage";
    name = "CC-Switch-${version}.AppImage";
    sha256 = "sha256-+NjzRMHzhUGppT9pYz+vJYBGdLVxlxzFQ1DEdPKlY2U=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit pname version name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/cc-switch.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/cc-switch.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    for size in $(ls ${appimageContents}/usr/share/icons/hicolor); do
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/''${size}/apps/cc-switch.png \
        $out/share/icons/hicolor/''${size}/apps/cc-switch.png
    done
  '';

  meta = with lib; {
    description = "A cross-platform desktop All-in-One assistant tool for Claude Code, Codex, OpenCode & Gemini CLI.";
    homepage = "https://github.com/farion1231/cc-switch";
    license = licenses.mit;
    maintainers = with maintainers; [ chen ];
    platforms = [ "x86_64-linux" ];
  };
}
