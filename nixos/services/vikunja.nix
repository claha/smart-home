{ config, lib, ... }:
let
  cfg = config.homelab.vikunja;
  domain = config.homelab.domain;
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
        frontendHostname = "vikunja.${domain}";
      };
    };

    networking.firewall.allowedTCPPorts = [ config.services.vikunja.port ];
  };
}
