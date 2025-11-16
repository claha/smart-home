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
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

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
