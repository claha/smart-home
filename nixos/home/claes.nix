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
    ./hyprland
    ./neovim
    ./qutebrowser
    ./voxtype
    ./wezterm
    ./web-apps
  ];

  home.username = "claes";
  home.homeDirectory = "/home/claes";
  home.stateVersion = "26.05";
}
