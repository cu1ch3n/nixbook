{ lib
, haskellPackages
, fetchFromGitHub
}:

haskellPackages.mkDerivation {
  pname = "autosubst2";
  version = "unstable-2022-07-04";
  src = fetchFromGitHub {
    owner = "uds-psl";
    repo = "autosubst2";
    rev = "8a71e1dc4dea81f13a9572ea302064eb374566c6";
    hash = "sha256-2vUYHtl9yAadwxxtsjTI0klP+nRSYGXVpaSwD9EBTTI=";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with haskellPackages; [ base parsec containers mtl array wl-pprint graphviz text ];
  executableHaskellDepends = with haskellPackages; [ base optparse-applicative wl-pprint directory ];
  homepage = "https://github.com/uds-psl/autosubst2";
  description = "Tool for generating de Bruijn boilerplate Coq code to handle substitutions in languages with binders";
  maintainers = with lib.maintainers; [ chen ];
  license = lib.licenses.bsd;
  mainProgram = "as2";
}