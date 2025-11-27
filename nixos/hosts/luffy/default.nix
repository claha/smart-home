{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../services
    ./../../services/homepage.nix
    ./../../services/traefik.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  networking = {
    networkmanager.enable = true;
    interfaces = {
      enp1s0 = {
        wakeOnLan.enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    just
  ];

  homelab = {
    audiobookshelf.enable = true;
    music-assistant.enable = true;
    jellyfin = {
      enable = true;
      hardwareAcceleration = true;
    };
    pinchflat.enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "24.05";
}
