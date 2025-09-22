{ config, pkgs, ... }:

let
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-image";
    src = ../../home/hyprpaper/brac.jpg;
    dontUnpack = true;
    installPhase = ''
      cp $src $out
    '';
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./../../services
      ./../../services/beszel-agent.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.wireless.iwd = {
    enable = true;
  };

  # Enable the KDE Plasma Desktop Environment
  services.displayManager.sddm = {
    enable = true;
    theme = "breeze";
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
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

  # Users
  users.users.claes = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$oLZK90Am5DVB.Cq1qlrlv1$jtVML8FNT8c9pRZjBvJ/xP895AkD8CqDgivA0FDt6Q9";
    packages = with pkgs; [
    ];
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    wget
    just
    gnupg
    pinentry-curses
    neovim
    firefox
    google-chrome
    microsoft-edge
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${background-package}"
    '')
  ];

  services.mullvad-vpn.enable = true;

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
  system.stateVersion = "25.05";
}
