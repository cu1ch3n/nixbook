{
  stdenv,
  fetchgit,
  haskellPackages,
  lib,
}:
with haskellPackages;
  mkDerivation {
    pname = "lngen";
    version = "b7de543";
    src = fetchgit {
      url = https://github.com/plclub/lngen;
      rev = "b7de543bd2c4e57ffb4848558a3a97e25c562254";
      sha256 = "In8Yi2Gs7koZ3K4BKHH2PpBePCOxspXMqVAnfY3r+Sw=";
    };
    isLibrary = true;
    isExecutable = true;
    libraryHaskellDepends = [base syb parsec containers mtl];
    executableHaskellDepends = [base];
    homepage = https://github.com/plclub/lngen;
    description = "Tool for generating Locally Nameless definitions and proofs in Coq, working together with Ott";
    license = lib.licenses.mit;
  }
