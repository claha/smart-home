{ config, pkgs, lib, hostname, ... }:

{
  networking.hostName = hostname;

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
  ];
}
