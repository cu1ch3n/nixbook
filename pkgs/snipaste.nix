{
  appimageTools,
  lib,
  fetchurl,
  ...
}: 
appimageTools.wrapType2 rec {
    pname = "snipaste";
    name = "snipaste";
    version = "2.8.9-Beta";

    src = fetchurl {
      url = "https://download.snipaste.com/archives/Snipaste-${version}-x86_64.AppImage";
      hash = "sha256-Qg2cfOvpMPq/ZLSP8nAgBMmWTGDE5cq3W6YOX6Zyfwk=";
    };

    meta = with lib; {
      description = "Snipaste is a simple but powerful snipping tool, and also allows you to pin the screenshot back onto the screen.";
      homepage = "https://www.snipaste.com";
      license = licenses.unfree;
      mainProgram = "Snipaste";
      platforms = ["x86_64-linux"];
    };
  }
