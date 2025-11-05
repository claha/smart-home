{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostname;

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

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
  ];

  environment.systemPackages = with pkgs; [
    wget
    screen
    gnupg
    pinentry-curses
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  networking.firewall = {
    enable = true;
  };

  users.users.root = {
    hashedPassword = "$y$j9T$34LfiN5xR4g6xgi1ISI.Z.$bgkESj4NELMNycLWNDykVm.XkxHbNaOMxET4/pJtZOD";
  };
}
