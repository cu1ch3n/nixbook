{ lib, fetchurl, appimageTools }:

let
  pname = "marvin";
  version = "1.62.0";
  name = "Marvin-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url = "https://amazingmarvin.s3.amazonaws.com/Marvin-${version}.AppImage";
    name = "Marvin-${version}.AppImage";
    sha256 = "sha256-RBcHnEGDnrTnfYpmLzeBmXd+H5sYHqewqp4FTRNMZ8M=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/marvin.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/marvin.desktop \
      --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
    for size in $(ls ${appimageContents}/usr/share/icons/hicolor); do
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/''${size}/apps/marvin.png \
        $out/share/icons/hicolor/''${size}/apps/marvin.png
    done
  '';

  meta = with lib; {
    description = "Marvin is the most feature rich and customizable personal to-do app on the market today.";
    homepage = "https://amazingmarvin.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
