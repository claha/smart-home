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
    homepage.enable = true;
    music-assistant.enable = true;
    jellyfin = {
      enable = true;
      hardwareAcceleration = true;
    };
    pinchflat.enable = true;
    traefik.enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "24.05";
}
