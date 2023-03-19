# NixOS

Been playing around with using nixos, this is to have somewhere to store the
configuration files during development.

## First step when installing this on my old laptop

Partition and generate initial config

```bash
$ sudo -i
# parted /dev/sda -- mklabel msdos
# parted /dev/sda -- mkpart primary 1MB -8GB
# parted /dev/sda -- set 1 boot on
# parted /dev/sda -- mkpart primary linux-swap -8GB 100%
# mkfs.btrfs -L nixos /dev/sda1
# mkswap -L swap /dev/sda2
# mount /dev/disk/by-label/nixos /mnt
# swapon /dev/sda2
# nixos-generate-config --root /mnt
```

Edit /mnt/etc/nixos/configuration.nix

```bash
# nixos-install
```

When changing stuff later

```bash
# nixos-rebuild switch
```
