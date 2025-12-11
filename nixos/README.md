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

Install NixOS on remote hosts via SSH. To ensure the target host can decrypt secrets,
create the `./tmp/etc/ssh` directory and add `ssh_host_ed25519_key` and `ssh_host_ed25519_key.pub`
files with appropriate permissions.

When reinstalling a host, copy the existing SSH host keys from the current host
before reinstalling, or generate new ones using:

```bash
ssh-keygen -t ed25519 -f ./tmp/etc/ssh/ssh_host_ed25519_key
```

When creating new SSH host keys, update `secrets.nix` in the secrets folder and
rekey all relevant secrets.

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#HOSTNAME\
  --generate-hardware-config nixos-generate-config ./hosts/HOSTNAME/hardware-configuration.nix\
  --target-host HOSTNAME --extra-files ./tmp
```
