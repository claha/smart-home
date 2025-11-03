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
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manager = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "transmission"
    ];
  };

  # List packages installed in system profile.
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
  system.stateVersion = "23.11";
}
