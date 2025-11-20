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
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Homelab services
  homelab = {
    ollama.enable = true;
    wyoming.enable = true;
  };

  environment.systemPackages = with pkgs; [
    just
  ];

  # Did you read the comment?
  system.stateVersion = "25.05";
}
