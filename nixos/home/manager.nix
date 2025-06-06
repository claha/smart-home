{ config, pkgs, ... }:

{
  imports = [
    ./bash
    ./git
  ];

  home.username = "manager";
  home.homeDirectory = "/home/manager";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    emacs-nox
    flexget
    spotdl
    svtplay-dl
    yt-dlp
  ];
}
