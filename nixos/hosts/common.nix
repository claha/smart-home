{ config, pkgs, lib, hostname, ... }:

{
  networking.hostName = hostname;
}
