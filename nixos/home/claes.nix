{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bash
    ./development
    ./emacs
    ./git
    ./mpv
    ./qutebrowser
    ./hyprland
    ./wezterm
    ./web-apps
  ];

  home.username = "claes";
  home.homeDirectory = "/home/claes";
  home.stateVersion = "25.05";
}
