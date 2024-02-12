{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix { inherit config pkgs; };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./services/audiobookshelf.nix
      ./services/glances.nix
      ./services/jellyfin.nix
      ./services/navidrome.nix
    ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the GRUB boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.supportedFilesystems = [ "ntfs" ];

  # Configure networking
  networking.hostName = "asus-nixos";
  networking.networkmanager.enable = true;
  networking.interfaces = {
    enp4s0 = {
      wakeOnLan = {
        enable = true;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
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
    extraGroups = [ "wheel" "docker" "transmission" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    screen
    restic
    autorestic
    just
    ffmpeg
    python3
    git
  ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

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

  # Configure acme
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "${secrets.email}";
      dnsProvider = "${secrets.dnsProvider}";
      credentialsFile = "${secrets.credentialsFile}";
    };
    certs."${secrets.domain}" = {
      domain = "${secrets.domain}";
      extraDomainNames = [ "*.media.${secrets.domain}" ];
    };
  };

  # Set up nginx
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # The nginx user needs to be able to read certificates
  users.users.nginx.extraGroups = [ "acme" ];

  # Enable tailscale
  services.tailscale.enable = true;

  # Enable transmission
  services.transmission = {
    enable = true;
    openRPCPort = true;
  };

  # Handle lid closing.
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    # 80, 443: nginx proxy manager
    allowedTCPPorts = [
      80
      443
    ];
    # Ephemeral ports (perhaps limit this using sysctl?)
    allowedUDPPortRanges = [{ from = 32768; to = 60999; }];
  };

  # Configure automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.stateVersion = "22.11"; # Did you read the comment?
}
