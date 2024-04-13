deploy:
  sudo nixos-rebuild switch --flake .#nixbook

debug:
  sudo nixos-rebuild switch --flake .#nixbook --show-trace --verbose

update:
  nix flake update --commit-lock-file
