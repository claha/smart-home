# NixOS Configuration

This directory contains NixOS configuration files and services for the smart home
setup.

## Overview

- Includes system-level configuration for NixOS
- Configuration for various home services

## Agenix

How to create a the hashedPasswordFile using agenix for a user.

```bash
$ mkdpasswd -m sha-512

$ nix run github:ryantm/agenix -- -e user-USERNAME-password.age
```
