# NixOS Configuration

This directory contains NixOS configuration files and services for the smart home
setup.

## Overview

- Includes system-level configuration for NixOS
- Configuration for various home services

## Agenix

How to create a the hashedPasswordFile using agenix for a user.

```bash
mkpasswd -m sha-512

nix run github:ryantm/agenix -- -e user-USERNAME-password.age
```

## NixOS Anywhere

Install NixOS everywhere via ssh.

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#HOSTNAME\
  --generate-hardware-config nixos-generate-config ./hosts/HOSTNAME/hardware-configuration.nix\
  --target-host HOSTNAME
```
