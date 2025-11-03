{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../services
    ./../../users/claes.nix
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
  users.users.malin = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
      zoom-us
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    microsoft-edge
  ];

  # Did you read the comment?
  system.stateVersion = "24.11";
}
