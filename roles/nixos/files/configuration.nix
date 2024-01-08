# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  secrets = import ./secrets.nix { inherit config pkgs; };
  navidromePort = 4533;
  bonobPort = 4534;
  jellyfinPort = 8096;
  audiobookshelfPort = 13378;
  glancesPort = 61208;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

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
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Terminus" ]; })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manager = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "transmission" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.manager = import ./home.nix;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    screen
    (python3.withPackages (ps: with ps; [ pipx ]))
    restic
    autorestic
    just
    glances
  ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    starship = {
      enable = true;
    };
  };

  # List services that you want to enable:

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

  # Navidrome and bonob
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {

      navidrome = {
        autoStart = true;
        image = "docker.io/deluan/navidrome:0.50.2";
        ports = [ "${toString navidromePort}:${toString navidromePort}" ];
        environment = {
          ND_SCANSCHEDULE = "1h";
        };
        volumes = [
          "/etc/navidrome/data:/data"
          "/media/music:/music:ro"
        ];
      };
      bonob = {
        autoStart = true;
        image = "ghcr.io/simojenki/bonob:v0.6.11";
        ports = [ "${toString bonobPort}:${toString bonobPort}" ];
        environment = {
          BNB_URL = "http://192.168.1.106:${toString bonobPort}";
          BNB_SONOS_AUTO_REGISTER = "true";
          BNB_SONOS_DEVICE_DISCOVERY = "true";
          BNB_SUBSONIC_URL = "http://192.168.1.106:${toString navidromePort}";
        };
        extraOptions = [ "--network=host" ];
      };

      jellyfin = {
        autoStart = true;
        image = "docker.io/jellyfin/jellyfin:10.8.13";
        volumes = [
          "/etc/jellyfin/config:/config"
          "/etc/jellyfin/cache:/cache"
          "/etc/jellyfin/log:/log"
          "/media:/media"
        ];
        ports = [ "${toString jellyfinPort}:${toString jellyfinPort}" ];
        environment = {
          JELLYFIN_LOG_DIR = "/log";
          JELLYFIN_PublishedServerUrl = "jellyfin.media.${secrets.domain}";
        };
      };

      audiobookshelf = {
        autoStart = true;
        image = "ghcr.io/advplyr/audiobookshelf:2.7.1";
        volumes = [
          "/etc/audiobookshelf/audiobooks:/audiobooks"
          "/etc/audiobookshelf/podcasts:/podcasts"
          "/etc/audiobookshelf/config:/config"
          "/etc/audiobookshelf/metadata:/metadata"
        ];
        ports = [ "${toString audiobookshelfPort}:80" ];
      };
    };
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
    virtualHosts = {
      "navidrome.media.${secrets.domain}" = {
        useACMEHost = "${secrets.domain}";
        acmeRoot = null;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:${toString navidromePort}"; proxyWebsockets = true; };
      };
      "jellyfin.media.${secrets.domain}" = {
        useACMEHost = "${secrets.domain}";
        acmeRoot = null;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:${toString jellyfinPort}"; proxyWebsockets = true; };
      };
      "audiobookshelf.media.${secrets.domain}" = {
        useACMEHost = "${secrets.domain}";
        acmeRoot = null;
        forceSSL = true;
        locations."/" = { proxyPass = "http://127.0.0.1:${toString audiobookshelfPort}"; proxyWebsockets = true; };
      };
    };
  };

  # The nginx user needs to be able to read certificates
  users.users.nginx.extraGroups = [ "acme" ];

  # Add backup service
  systemd.timers."autorestic_backup_navidrome" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "0/6:00:00";
      RandomizedDelaySec = 600;
      Unit = "autorestic_backup_navidrome.service";
    };
  };

  systemd.services."autorestic_backup_navidrome" = {
    script = "autorestic --config /etc/autorestic.yaml --verbose backup --location navidrome";
    serviceConfig = {
      Type = "simple";
      User = "root";
    };
    path = [
      pkgs.autorestic
      pkgs.restic
      pkgs.bash
      pkgs.curl
    ];
  };

  # Add glances service
  systemd.services."glances" = {
    script = "glances --webserver --disable-webui";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = "root";
      Restart = "on-abort";
      RemainAfterExit = "yes";
    };
    path = [
      pkgs.glances
    ];
  };

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
    # 1400: Sonos app control
    allowedTCPPorts = [
      80
      443
      1400
      navidromePort
      bonobPort
      jellyfinPort
      audiobookshelfPort
      glancesPort
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
