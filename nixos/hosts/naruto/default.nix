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
    ./../../services/gatus.nix
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
    gnupg
    pinentry-curses
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Enable transmission
  services.transmission = {
    enable = true;
    openRPCPort = true;
  };

  homelab = {
    it-tools.enable = true;
    karakeep.enable = true;
    beszel-hub.enable = true;
    vikunja.enable = true;
    mealie.enable = true;
    ntfy.enable = true;
  };

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    # Ephemeral ports (perhaps limit this using sysctl?)
    allowedUDPPortRanges = [
      {
        from = 32768;
        to = 60999;
      }
    ];
  };

  # Did you read the comment?
  system.stateVersion = "23.11";
}
