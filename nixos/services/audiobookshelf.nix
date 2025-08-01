{ config, lib, pkgs, ... }:

let
  cfg = config.myServices.audiobookshelf;
in
{
  options.myServices.audiobookshelf = {
    enable = lib.mkEnableOption "Audiobookshelf";
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      package = pkgs.unstable.audiobookshelf;
      host = "0.0.0.0";
      port = 13378;
      openFirewall = true;
    };
  };
}
