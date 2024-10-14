# It doesn't work. It is a shame that the Agda Language Server uses lsp < 2.
{
  lib,
  haskellPackages,
  fetchFromGitHub,
}:
haskellPackages.mkDerivation rec {
  pname = "agda-language-server";
  version = "0.2.6.4.0.3";
  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-language-server";
    rev = "v${version}";
    hash = "sha256-87NBPh2esMLXchvHlyi0s1dJKX5ZaWzBEYkGwij2jd4=";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with haskellPackages; [
    base
    Agda
    aeson
    bytestring
    containers
    directory
    filepath
    lsp-types
    lsp
    mtl
    network
    network-simple
    strict
    stm
    text
    process
    prettyprinter
  ];
  executableHaskellDepends = with haskellPackages; [
    base
    Agda
    aeson
    bytestring
    containers
    directory
    filepath
    lsp-types
    lsp
    mtl
    network
    network-simple
    strict
    stm
    text
    process
    prettyprinter
  ];
  homepage = "https://github.com/agda/agda-language-server";
  description = "Language Server for Agda";
  maintainers = with lib.maintainers; [chen];
  license = lib.licenses.mit;
  mainProgram = "als";
}
