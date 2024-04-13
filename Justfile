deploy:
  sudo nixos-rebuild switch --flake .#nixbook |& nom

debug:
  sudo nixos-rebuild switch --flake .#nixbook --show-trace --verbose |& nom

update:
  nix flake update --commit-lock-file |& nom
