{ config, lib, ... }:
let
  cfg = config.homelab.vikunja;
in
{
  options.homelab.vikunja = {
    enable = lib.mkEnableOption "Vikunja to-do";
  };

  config = lib.mkIf cfg.enable {
    services = {
      vikunja = {
        enable = true;
        frontendScheme = "https";
        frontendHostname = "vikunja.hallstrom.duckdns.org";
      };
    };

    networking.firewall.allowedTCPPorts = [ config.services.vikunja.port ];
  };
}
