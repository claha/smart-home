{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
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
  networking.hostName = "yoga";
  networking.networkmanager.enable = true;

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
