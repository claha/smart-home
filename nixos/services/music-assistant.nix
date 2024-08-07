{ config, pkgs, ... }:

let
  musicAssistantPort = 8095;
  musicAssistantStreamPort = 8097;
  sonosAppCtrlPort = 1400;
in
{
  virtualisation.oci-containers.containers = {
    music-assistant = {
      autoStart = true;
      image = "ghcr.io/music-assistant/server:2.1.1";
      volumes = [
        "/etc/music-assistant/data:/data"
        "/media/music:/media:ro"
      ];
      extraOptions = [ "--network=host" "--privileged" ];
    };
  };

  services.nginx.virtualHosts."music.media.hallstrom.duckdns.org" = {
    useACMEHost = "hallstrom.duckdns.org";
    acmeRoot = null;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString musicAssistantPort}"; proxyWebsockets = true; };
  };

  networking.firewall.allowedTCPPorts = [ musicAssistantPort musicAssistantStreamPort sonosAppCtrlPort ];
}
