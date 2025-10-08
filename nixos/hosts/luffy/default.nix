{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../services
      ./../../services/homepage.nix
      ./../../services/nextcloud.nix
      ./../../services/pinchflat.nix
      ./../../services/traefik.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manager = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  homelab = {
    audiobookshelf.enable = true;
    jellyfin = {
      enable = true;
      hardwareAcceleration = true;
    };
  };

  # Did you read the comment?
  system.stateVersion = "24.05";
}
