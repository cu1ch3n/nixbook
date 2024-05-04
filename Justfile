rebuild:
  sudo nixos-rebuild switch --flake .#nixbook |& nom

debug:
  sudo nixos-rebuild switch --flake .#nixbook --show-trace --verbose |& nom

test:
  sudo nixos-rebuild test --flake .#nixbook --show-trace --verbose |& nom

clean:
  nix-collect-garbage -d

update:
  nix flake update --commit-lock-file |& nom
