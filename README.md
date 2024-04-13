# Chen's NixBook Configurations

## Components

- Desktop: GNOME
- Wallpaper: KDE 6 default wallpaper :)

## Preview

### Light
![](assets/screenshot-light.png)

### Dark
![](assets/screenshot-dark.png)

## Update NixOS configuration

```console
sudo nixos-rebuild switch --flake .#nixbook
```

## Update flake lock file

You may use
```console
nix flake update --commit-lock-file
```
to update `flake.lock`.
