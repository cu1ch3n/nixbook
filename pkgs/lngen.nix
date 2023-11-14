{
  stdenv,
  fetchFromGitHub,
  haskellPackages,
  lib,
}:
with haskellPackages;
  mkDerivation {
    pname = "lngen";
    version = "unstable-2023-10-17";
    src = fetchFromGitHub {
      owner = "plclub";
      repo = "lngen";
      rev = "c7645001404e0e2fec2c56f128e30079b5b3fac6";
      sha256 = "2vUYHtl9yAadwdTtsjTI0klP+nRSYGXVpaSwD9EBTTI=";
    };
    isLibrary = true;
    isExecutable = true;
    libraryHaskellDepends = [base syb parsec containers mtl];
    executableHaskellDepends = [base];
    homepage = https://github.com/plclub/lngen;
    description = "Tool for generating Locally Nameless definitions and proofs in Coq, working together with Ott";
    license = lib.licenses.mit;
  }
