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
    ./hex
    ./neovim
    ./qutebrowser
    ./terminal-apps
    ./wezterm
    ./web-apps
  ];

  home.username = "claes";
  home.homeDirectory = "/home/claes";
  home.stateVersion = "26.05";
  home.packages = [
    pkgs.mcp-nixos
  ];
}
