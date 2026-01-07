{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.immich;
in
{
  options.homelab.immich = {
    enable = lib.mkEnableOption "Immich";
  };
  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /data/immich 0775 ${config.services.immich.user} ${config.services.immich.group} - -"
    ];

    services.immich = {
      enable = true;
      package = pkgs.immich;
      host = "0.0.0.0";
      port = 2283;
      database.enable = true;
      redis.enable = true;
      machine-learning.enable = true;
      openFirewall = true;
      mediaLocation = "/data/immich";
      accelerationDevices = null;
    };

    networking.firewall.allowedTCPPorts = [ 3001 ];
  };
}
