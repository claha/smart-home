{ config, lib, ... }:
let
  cfg = config.homelab.transmission;
in
{
  options.homelab.transmission = {
    enable = lib.mkEnableOption "Transmission bit torrent";
  };

  config = lib.mkIf cfg.enable {
    services.transmission = {
      enable = true;
      openRPCPort = true;
    };
  };
}
