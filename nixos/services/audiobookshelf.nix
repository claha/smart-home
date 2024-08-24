{ config, pkgs, ... }:
{
  services.audiobookshelf = {
    enable = true;
    package = pkgs.unstable.audiobookshelf;
    host = "0.0.0.0";
    port = 13378;
    openFirewall = true;
  };
}
