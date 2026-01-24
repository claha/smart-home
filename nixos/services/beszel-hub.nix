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
  };

  config = lib.mkIf cfg.enable {
    services.beszel.hub = {
      enable = true;
      host = "0.0.0.0";
      environment = {
        SHARE_ALL_SYSTEMS = "true";
        USER_CREATION = "true";
        DISABLE_PASSWORD_AUTH = "true";
      };
    };

    networking.firewall.allowedTCPPorts = [ config.services.beszel.hub.port ];
  };
}
