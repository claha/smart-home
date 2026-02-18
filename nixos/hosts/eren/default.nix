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

  # Networking
  networking = {
    interfaces = {
      eno1 = {
        wakeOnLan.enable = true;
      };
      ens2 = {
        wakeOnLan.enable = true;
      };
    };
  };

  services.snapper = {
    cleanupInterval = "1d";
    persistentTimer = false;
    snapshotInterval = "*:0/15";
    snapshotRootOnBoot = false;
    filters = null;
    configs = {
      home = {
        SUBVOLUME = "/home";
        FSTYPE = "btrfs";
        ALLOW_USERS = [ ];
        ALLOW_GROUPS = [ ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 12;
        TIMELINE_LIMIT_QUARTERLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };

  homelab = {
    memos.enable = true;
    ollama.enable = true;
    wyoming.enable = true;
    immich.enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "25.05";
}
