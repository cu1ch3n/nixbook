{
  fetchFromGitHub,
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-hyprcursor";
  version = "4.0.0";

  src = "${
    fetchFromGitHub {
      owner = "dracula";
      repo = "gtk";
      rev = "4.0.0";
      hash = "sha256-q3/uBd+jPFhiVAllyhqf486Jxa0mnCDSIqcm/jwGtJA=";
    }
  }/kde/cursors";

  buildInputs = builtins.attrValues {
    inherit (pkgs)
      hyprcursor
      xcur2png
      ;
  };

  installPhase = ''
    hyprcursor-util --extract ./Dracula-cursors
    hyprcursor-util --create ./extracted_Dracula-cursors

    cat <<EOF > ./extracted_Dracula-cursors/manifest.hl
    name = Dracula-cursors
    description = Automatically extracted with hyprcursor-util
    version = 0.1
    cursors_directory = hyprcursors
    EOF

    mv 'theme_Extracted Theme' $out
  '';
}
