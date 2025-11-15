{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.beszel-hub;
in
{
  options.homelab.beszel-hub = {
    enable = lib.mkEnableOption "Beszel Hub";
    port = lib.mkOption {
      type = lib.types.port;
      default = 3001;
      description = "Port for Beszel Hub";
    };
  };

  config = lib.mkIf cfg.enable {
    services.beszel.hub = {
      enable = true;
      host = "0.0.0.0";
      port = cfg.port;
      environment = {
        SHARE_ALL_SYSTEMS = "true";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
