{ config, lib, pkgs, ... }:

{
  imports = [
    ./bash
    ./emacs
    ./git
    ./mpv
    ./qutebrowser
    ./rofi
    ./hyprland
    ./wezterm
  ];

  home.username = "claes";
  home.homeDirectory = "/home/claes";
  home.stateVersion = "25.05";
}
