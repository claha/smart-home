{ config, lib, ... }:
let
  cfg = config.homelab.ntfy;
  domain = config.homelab.domain;
in
{
  options.homelab.ntfy = {
    enable = lib.mkEnableOption "Ntfy push notifications";
  };
  config = lib.mkIf cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://ntfy.${domain}";
        listen-http = ":2586";
        behind-prxy = true;
      };
    };

    networking.firewall.allowedTCPPorts = [ 2586 ];
  };
}
