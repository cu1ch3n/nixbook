{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "quartz";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OivDSADpfhvMKqTHCvDCpHrZDipA1H8jxLiacdmLseU=";
  };

  npmDepsHash = "sha256-eHYCSUWI39Agbu2reA9u2MtDyQJ0mz2Mkb7GW/aR8Yc=";
  # npmPackFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;
  npmInstallFlags = [ "--save" ];

  meta = with lib; {
    description = "Quartz is a set of tools that helps you publish your digital garden and notes as a website for free. Quartz v4 features a from-the-ground rewrite focusing on end-user extensibility and ease-of-use.";
    homepage = "https://quartz.jzhao.xyz/";
    license = licenses.mit;
  };
}
