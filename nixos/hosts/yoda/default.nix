{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../config/nix.nix
      ./../../config/swedish.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs.autoScrub.enable = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostId = "11d742f9";
  services.mullvad-vpn.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.claes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$y$j9T$oLZK90Am5DVB.Cq1qlrlv1$jtVML8FNT8c9pRZjBvJ/xP895AkD8CqDgivA0FDt6Q9";
  };

  environment.systemPackages = with pkgs; [
    wget
    just
    gnupg
    pinentry-curses
    git
    vim
    firefox
  ];

  # Greeter
  security.polkit.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --cmd sway
      '';
    };
  };

  security.pam.services.swaylock = { };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Enable and configure the firewall.
  networking.firewall = {
    enable = true;
  };

  # Use stylix
  stylix = {
    enable = true;
    image = ./brac.jpg;
    opacity = {
      terminal = 0.7;
      desktop = 0.7;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/pinky.yaml";
    override = {
      base0D = "ff8c00";
    };
  };

  # Did you read the comment?
  system.stateVersion = "24.05";
}
