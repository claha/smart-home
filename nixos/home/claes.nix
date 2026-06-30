{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./agents
    ./bash
    ./development
    ./emacs
    ./git
    ./neovim
    ./qutebrowser
    ./hyprland
    ./wezterm
    ./web-apps
  ];

  home.username = "claes";
  home.homeDirectory = "/home/claes";
  home.stateVersion = "26.05";
}
