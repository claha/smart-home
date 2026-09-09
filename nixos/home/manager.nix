{ config, pkgs, ... }:

{
  imports = [
    ./agents
    ./bash
    ./development
    ./git
  ];

  home.username = "manager";
  home.homeDirectory = "/home/manager";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    emacs-nox
  ];
}
