# Chen's NixBook Configurations

## NixOS

```console
sudo nixos-rebuild switch --flake .#nixbook
```

## Update

You may use
```console
nix flake update --commit-lock-file
```
to update `flake.lock`.
