{
  config,
  pkgs,
  homeUser,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../services
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.wireless.iwd = {
    enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable autlogin and hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = homeUser;
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
        user = homeUser;
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
