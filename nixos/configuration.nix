# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Configure networking
  networking.hostName = "asus-nixos";
  networking.networkmanager.enable = true;

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
    extraGroups = [ "wheel" "docker" ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    emacs-nox
    wget
  ];

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
  };

  # Navidrome and bonob
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {

      navidrome = {
        autoStart = true;
        image = "deluan/navidrome:0.49.3";
        ports = [ "4533:4533" ];
        # environment = {}
        volumes = [
          "/etc/navidrome/data:/data"
          "/media/music:/music:ro"
        ];
      };
      bonob = {
        autoStart = true;
        image = "simojenki/bonob:v0.6.5";
        ports = [ "4534:4534" ];
        environment = {
          BNB_URL = "http://192.168.1.106:4534";
          BNB_SONOS_AUTO_REGISTER = "true";
          BNB_SONOS_DEVICE_DISCOVERY = "true";
          BNB_SUBSONIC_URL = "http://192.168.1.106:4533";
        };
        extraOptions = [ "--network=host" ];
      };
    };
  };

  # Handle lid closing.
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
    # 1400: Sonos app control
    # 4533: bonob (perhaps not needed, handled by docker config?)
    # 4534: Navidrom (perhaps not needed, handled by docker config?)
    allowedTCPPorts = [ 1400 4533 4534 ];
    # Ephemeral ports (perhaps limit this using sysctl?)
    allowedUDPPortRanges = [{ from = 32768; to = 60999; }];
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
