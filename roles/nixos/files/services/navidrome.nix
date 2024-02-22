{ config, pkgs, ... }:

let
  secrets = import ../secrets.nix { inherit config pkgs; };
  bonobPort = 4534;
  navidromePort = 4533;
  sonosAppCtrlPort = 1400;
in
{
  virtualisation.oci-containers.containers = {
    navidrome = {
      autoStart = true;
      image = "docker.io/deluan/navidrome:0.51.1";
      ports = [ "${toString navidromePort}:${toString navidromePort}" ];
      environment = {
        ND_SCANSCHEDULE = "1h";
      };
      volumes = [
        "/etc/navidrome/data:/data"
        "/media/music:/music:ro"
      ];
    };
    bonob = {
      autoStart = true;
      image = "ghcr.io/simojenki/bonob:v0.7.0";
      ports = [ "${toString bonobPort}:${toString bonobPort}" ];
      environment = {
        BNB_URL = "http://192.168.1.49:${toString bonobPort}";
        BNB_SONOS_AUTO_REGISTER = "true";
        BNB_SONOS_DEVICE_DISCOVERY = "true";
        BNB_SUBSONIC_URL = "http://192.168.1.49:${toString navidromePort}";
      };
      extraOptions = [ "--network=host" ];
    };
  };

  services.nginx.virtualHosts."navidrome.media.${secrets.domain}" = {
    useACMEHost = "${secrets.domain}";
    acmeRoot = null;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString navidromePort}"; proxyWebsockets = true; };
  };

  systemd.timers."autorestic_backup_navidrome" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "0/6:00:00";
      RandomizedDelaySec = 600;
      Unit = "autorestic_backup_navidrome.service";
    };
  };

  systemd.services."autorestic_backup_navidrome" = {
    script = "autorestic --config /etc/autorestic.yaml --verbose backup --location navidrome";
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

  networking.firewall.allowedTCPPorts = [ bonobPort navidromePort sonosAppCtrlPort ];
}
