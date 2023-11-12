# Chen's NixBook Configurations

## Bootstrap

If you don't have flake or home-manager enabled in your current system, you may run
```console
$ nix develop
```
to enter the bootstrap envitonment.

## NixOS

```console
[nix-shell]$ sudo nixos-rebuild switch --flake .#nixbook
```

## Home Manager

```console
[nix-shell]$ home-manager switch --flake .#chen@nixbook
```

## Update

You may use
```console
$ nix flake update --commit-lock-file
```
to update `flake.lock`.
