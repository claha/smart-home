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
    ./../../services/ollama.nix
    ./../../services/wyoming.nix
    ./../../users/manager.nix
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

  environment.systemPackages = with pkgs; [
    just
  ];

  # Did you read the comment?
  system.stateVersion = "24.11";
}
