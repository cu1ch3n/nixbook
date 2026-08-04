rebuild:
  sudo nixos-rebuild switch --flake .#nixbook

debug:
  sudo nixos-rebuild switch --flake .#nixbook --show-trace --verbose

test:
  sudo nixos-rebuild test --flake .#nixbook --show-trace --verbose

check:
  nix flake check --no-build --show-trace

format:
  nix fmt .

clean:
  nix-collect-garbage -d

update:
  nix flake update --commit-lock-file

update-codex:
  nix flake update nixpkgs-master
