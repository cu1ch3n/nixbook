rebuild:
  sudo nixos-rebuild switch --flake .#nixbook

debug:
  sudo nixos-rebuild switch --flake .#nixbook --show-trace --verbose

test:
  sudo nixos-rebuild test --flake .#nixbook --show-trace --verbose

clean:
  nix-collect-garbage -d

update:
  nix flake update --commit-lock-file
