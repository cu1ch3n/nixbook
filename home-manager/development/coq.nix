{ pkgs, ... }:
{
  home.packages = [ pkgs.rocq-core_9_1 ] ++ (with pkgs; [ vsrocq-language-server-mcp ]);

  # A Note from Chen:
  #
  # Well, I guess it is a bit hard to set up the environment properly if the
  # Coq library is installed globally. Let's use nix-shell instead. Below is
  # an example:
  #
  # {pkgs ? import <nixpkgs> {}}:
  # pkgs.mkShell {
  #   nativeBuildInputs = with pkgs.coqPackages_8_19; [
  #     coq
  #     autosubst
  #     coq-hammer
  #     coq-hammer-tactics
  #   ];
  # }
  #
  # To use it you can type `nix-shell` in the terminal. Or you can use the
  # VSCode extension `arrterian.nix-env-selector` to apply the environment.
}
