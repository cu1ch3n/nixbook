{ pkgs, ... }:
let
  json2nix = pkgs.writeScriptBin "json2nix" ''
    ${pkgs.python3}/bin/python ${pkgs.fetchurl {
      url = "https://gist.githubusercontent.com/Scoder12/0538252ed4b82d65e59115075369d34d/raw/e86d1d64d1373a497118beb1259dab149cea951d/json2nix.py";
      hash = "sha256-ROUIrOrY9Mp1F3m+bVaT+m8ASh2Bgz8VrPyyrQf9UNQ=";
    }} $@
  '';
in
{
  home.packages = with pkgs; [
    json2nix
    comma
    deadnix
    nixd
    nix-init
    nixpkgs-fmt
    nixpkgs-review
    statix
    yarn
    yarn2nix
  ];
}
