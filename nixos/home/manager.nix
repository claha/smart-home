{ config, pkgs, ... }:

{
  imports = [
    ./bash
    ./git
  ];

  home.username = "manager";
  home.homeDirectory = "/home/manager";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    emacs-nox
  ];
}
