{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../services
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.wireless.iwd = {
    enable = true;
  };

  # Enable autlogin and hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = "claes";
      };
    };
  };
  programs.hyprland.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  homelab = {
    docker.enable = true;
  };

  myServices.udev = {
    enable = true;
    devices = [
      {
        serial = "E0C9125B0D9B";
        mountPoint = "/mnt/rp2040";
        user = "claes";
      }
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    just
    neovim
    firefox
    google-chrome
    microsoft-edge
    bitwarden-desktop
  ];

  # Did you read the comment?
  system.stateVersion = "25.05";
}
