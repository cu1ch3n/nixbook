#!/usr/bin/env bash

sudo -i

# Partitioning, formatting and mounting
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode zap_create_mount ./disko.nix

# Installing
nixos-install --flake https://github.com/cu1ch3n/nixbook#nixbook --no-root-passwd

# Setting up password files
mkdir -p /mnt/persist/passwordFiles
mkpasswd -m SHA-512 -s > /mnt/persist/passwordFiles/root
mkpasswd -m SHA-512 -s > /mnt/persist/passwordFiles/chen
