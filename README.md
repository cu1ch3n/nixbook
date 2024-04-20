[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
[![Cachix Cache](https://img.shields.io/badge/cachix-chen-blue.svg)](https://chen.cachix.org)

# NixBook: Chen's NixOS Configurations

Welcome to NixBook, a repository where I share my NixOS and home-manager configuration files for my EliteBook.

## Highlights

- **Tmpfs as root & home**: Automatically erases the root (`/`) and home (`/home`) on each boot, ensuring a clean state. Persistent data is managed by the [Impermanence] module (See [tmpfs as root] and [tmpfs as home] for more details).
- **Encrypted single Btrfs partition**: add password protection for the disk, enable easy snapshot backups
- **Declarative disk partitioning**: eliminates the need for manual partitioning, mounting, and unmounting required during the installation phase
- **Efficient Desktop Environment**: Optimized for productivity with minimal distractions, featuring only essential visual elements. It supports an automatic switch between light and dark themes.
- **Theorem proving toolchains in PL research**: `abella`, `coq`, `lngen` and `ott` toolchain stuff. Packages maintained by me:
    - `nixpkgs`: [`lngen`]
    - [`nur.repos.chen`]: forked version of `abella` ([`abella-modded`]) and `ott` ([`ott-sweirich`])

## Installation

To install the Nixbook configurations on your system, start by booting your computer with a LiveCD. Once you have successfully booted into the LiveCD environment, open a terminal and enter:

```
git clone https://github.com/cu1ch3n/nixbook
cd nixbook/script
chmod +x ./install.sh
./install.sh
```

## Post-installation

After the installation, there are a few settings that need to be configured manually. These settings are not managed declaratively through NixOS:
- Set user fingerprint
- 1Password SSH & CLI integration

## Rebuild NixOS configuration

```console
just rebuild
```

## Update flake lock file

```console
just update
```

## Preview

### Light
![](assets/screenshot-light.png)

### Dark
![](assets/screenshot-dark.png)

[`abella-modded`]: https://github.com/nix-community/nur-combined/tree/master/repos/chen/pkgs/abella-modded/default.nix
[`ott-sweirich`]: https://github.com/nix-community/nur-combined/tree/master/repos/chen/pkgs/ott-sweirich/default.nix
[`lngen`]: https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ln/lngen/package.nix
[`nur.repos.chen`]: https://nur.nix-community.org/repos/chen/
[Impermanence]: https://github.com/nix-community/impermanence
[tmpfs as root]: https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/
[tmpfs as home]: https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/