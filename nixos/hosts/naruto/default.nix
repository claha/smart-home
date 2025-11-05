{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ./../../services
    ./../../users/manager.nix
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
    it-tools.enable = true;
    karakeep.enable = true;
    beszel-hub.enable = true;
    vikunja.enable = true;
    mealie.enable = true;
    ntfy.enable = true;
    gatus.enable = true;
    transmission.enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "25.05";
}
