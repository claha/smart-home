{ config, pkgs, ... }:

let
  audiobookshelfPort = 13378;
in
{
  virtualisation.oci-containers.containers.auidobookshelf = {
    autoStart = true;
    image = "ghcr.io/advplyr/audiobookshelf:2.11.0";
    volumes = [
      "/media/podcasts:/podcasts"
      "/media/audiobooks:/audiobooks"
      "/etc/audiobookshelf/config:/config"
      "/etc/audiobookshelf/metadata:/metadata"
    ];
    ports = [ "${toString audiobookshelfPort}:80" ];
  };

  services.nginx.virtualHosts."audiobookshelf.media.hallstorm.duckdns.org" = {
    useACMEHost = "hallstrom.duckdns.org";
    acmeRoot = null;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString audiobookshelfPort}"; proxyWebsockets = true; };
  };

  systemd.timers."autorestic_backup_audiobookshelf" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "0/6:00:00";
      RandomizedDelaySec = 600;
      Unit = "autorestic_backup_audiobookshelf.service";
    };
  };

  systemd.services."autorestic_backup_audiobookshelf" = {
    script = "autorestic --config /etc/autorestic.yaml --verbose backup --location audiobookshelf";
    serviceConfig = {
      Type = "simple";
      User = "root";
    };
    path = [
      pkgs.autorestic
      pkgs.restic
      pkgs.bash
      pkgs.curl
    ];
  };

  networking.firewall.allowedTCPPorts = [ audiobookshelfPort ];
}
