{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.pocket-id;
in
{
  options.homelab.pocket-id = {
    enable = lib.mkEnableOption "Pocket ID";
  };

  config = lib.mkIf cfg.enable {
    services.pocket-id = {
      enable = true;
      settings = {
        TRUST_PROXY = true;
        APP_URL = "https://id.hallstrom.duckdns.org";
        ANALYTICS_DISABLED = true;
      };
    };

    networking.firewall.allowedTCPPorts = [ 1411 ];
  };
}
