{ config, pkgs, ... }:

let
  secrets = import ../secrets.nix { inherit config pkgs; };
  jellyfinPort = 8096;
in
{
  virtualisation.oci-containers.containers.jellyfin = {
    autoStart = true;
    image = "docker.io/jellyfin/jellyfin:10.8.13";
    volumes = [
      "/etc/jellyfin/config:/config"
      "/etc/jellyfin/cache:/cache"
      "/etc/jellyfin/log:/log"
      "/media:/media"
    ];
    ports = [ "${toString jellyfinPort}:${toString jellyfinPort}" ];
    environment = {
      JELLYFIN_LOG_DIR = "/log";
      JELLYFIN_PublishedServerUrl = "jellyfin.media.${secrets.domain}";
    };
  };

  services.nginx.virtualHosts."jellyfin.media.${secrets.domain}" = {
    useACMEHost = "${secrets.domain}";
    acmeRoot = null;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString jellyfinPort}"; proxyWebsockets = true; };
  };

  networking.firewall.allowedTCPPorts = [ jellyfinPort ];
}
