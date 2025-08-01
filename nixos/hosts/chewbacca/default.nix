{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../services/beszel-hub.nix
      ./../../services/beszel-agent.nix
      ./../../services/gatus.nix
      ./../../services/it-tools.nix
      ./../../services/karakeep.nix
      ./../../services/music-assistant.nix
      ./../../services/mealie.nix
      ./../../services/ntfy.nix
      ./../../services/tailscale.nix
      ./../../services/vikunja.nix
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
    extraGroups = [ "wheel" "networkmanager" "transmission" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    screen
    restic
    autorestic
    just
    gnupg
    pinentry-curses
    python3
    git
    vim
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable transmission
  services.transmission = {
    enable = true;
    openRPCPort = true;
  };

  # Enable mullvad
  services.mullvad-vpn.enable = true;

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    # Ephemeral ports (perhaps limit this using sysctl?)
    allowedUDPPortRanges = [{ from = 32768; to = 60999; }];
  };

  # Did you read the comment?
  system.stateVersion = "23.11";
}
