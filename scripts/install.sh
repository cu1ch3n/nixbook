#!/usr/bin/env bash

sudo -i

# Partitioning and formatting
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
parted /dev/nvme0n1 -- set 1 boot on
parted /dev/nvme0n1 -- mkpart nix 512MB -64GB
parted /dev/nvme0n1 -- mkpart swap linux-swap -64GB 100%

mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nix /dev/nvme0n1p2
mkswap -L swap /dev/nvme0n1p3

# Mounting
mount -t tmpfs none /mnt

mkdir -p /mnt/{boot,nix,etc/nixos,var/log,passwordFiles}
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p2 /mnt/nix

mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/nix/persist/var/log /mnt/var/log

swapon /dev/nvme0n1p3

# Installing
nixos-install --flake https://github.com/cu1ch3n/nixbook#nixbook --no-root-passwd
nix-shell --run 'mkpasswd -m SHA-512 -s > /nix/persist/passwordFiles/root' -p mkpasswd
nix-shell --run 'mkpasswd -m SHA-512 -s > /nix/persist/passwordFiles/chen' -p mkpasswd
