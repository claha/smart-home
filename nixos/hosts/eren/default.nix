{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../config/nix.nix
      ./../../config/swedish.nix
      ./../../services/tailscale.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];

  # ZFS
  services.zfs.autoScrub.enable = true;

  # Networking
  networking.hostId = "d00babfa";

  # Define users
  users.users.manager = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    screen
    just
    gnupg
    pinentry-curses
    python3
    git
    vim
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Enable ssh
  services.openssh.enable = true;

  # Firewall
  networking.firewall = {
    enable = false;
  };

  # Did you read the comment?
  system.stateVersion = "24.11";
}
