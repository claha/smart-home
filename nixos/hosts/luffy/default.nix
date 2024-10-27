{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../services/audiobookshelf.nix
      ./../../services/homepage.nix
      ./../../services/nextcloud.nix
    ];

  # Nix stuff
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "luffy";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Time zone, keyboard, language
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };

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
    figurine
  ];

  programs.bash.interactiveShellInit = "${pkgs.figurine}/bin/figurine -f 3d.flf luffy";

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;

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
