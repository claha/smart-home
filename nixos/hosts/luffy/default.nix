{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../config/nix.nix
      ./../../config/swedish.nix
      ./../../services/audiobookshelf.nix
      ./../../services/homepage.nix
      ./../../services/jellyfin.nix
      ./../../services/nextcloud.nix
      ./../../services/ollama.nix
      ./../../services/pinchflat.nix
      ./../../services/tailscale.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Install terminess nerdfont
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Terminus" ]; })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manager = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    wget
    screen
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

  # Traefik
  environment.etc.traefik = {
    source = ./../../services/traefik;
    user = "traefik";
    group = "traefik";
  };
  services.traefik = {
    enable = true;
    staticConfigFile = "/etc/traefik/static.yaml";
    # environmentFiles = [ config.age.secrets.duckdns-token.path ];  # Bug? Can not be used with staticConfigFile
  };
  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets.duckdns-token.path;
  };

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  # Did you read the comment?
  system.stateVersion = "24.05";
}
