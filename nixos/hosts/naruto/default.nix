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
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  networking = {
    networkmanager.enable = true;
    interfaces = {
      enp1s0 = {
        wakeOnLan.enable = true;
      };
      enp2s0 = {
        wakeOnLan.enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    just
  ];

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
    it-tools.enable = true;
    karakeep.enable = true;
    beszel-hub.enable = true;
    vikunja.enable = true;
    mealie.enable = false;
    ntfy.enable = true;
    gatus.enable = true;
    transmission.enable = true;
    pocket-id.enable = true;
    blocky.enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "25.05";
}
