{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../services/gatus.nix
      ./../../services/glances.nix
      ./../../services/jellyfin.nix
      ./../../services/music-assistant.nix
      ./../../services/navidrome.nix
      ./../../services/wyoming.nix
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
  networking.hostName = "chewbacca";
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
    extraGroups = [ "wheel" "networkmanager" "docker" "transmission" ];
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
    figurine
  ];

  programs.bash.interactiveShellInit = "${pkgs.figurine}/bin/figurine -f 3d.flf chewbacca";

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable docker
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      flags = [ "--all" "--volumes" ];
    };
  };
  virtualisation.oci-containers = {
    backend = "docker";
  };

  # Enable tailscale
  services.tailscale.enable = true;

  # Enable transmission
  services.transmission = {
    enable = true;
    openRPCPort = true;
  };

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    # Ephemeral ports (perhaps limit this using sysctl?)
    allowedUDPPortRanges = [{ from = 32768; to = 60999; }];
  };

  # Did you read the comment?
  system.stateVersion = "23.11";
}
