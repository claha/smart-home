{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../services/tailscale.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users
  users.users.claes = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$y$j9T$oLZK90Am5DVB.Cq1qlrlv1$jtVML8FNT8c9pRZjBvJ/xP895AkD8CqDgivA0FDt6Q9";
    packages = with pkgs; [
    ];
  };

  users.users.malin = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    wget
    just
    gnupg
    pinentry-curses
    git
    vim
    firefox
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # GPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Firewall
  networking.firewall = {
    enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "24.11";
}
