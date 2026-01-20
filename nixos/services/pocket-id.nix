{
  config,
  lib,
  pkgs,
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
      package = pkgs.unstable.pocket-id;
      settings = {
        TRUST_PROXY = true;
        APP_URL = "https://id.hallstrom.duckdns.org";
        ANALYTICS_DISABLED = true;
      };
      environmentFile = config.age.secrets.pocket-id.path;
    };

    networking.firewall.allowedTCPPorts = [ 1411 ];
  };
}
