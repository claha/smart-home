{ config, pkgs, ... }:

let
  navidromePort = 4533;
in
{
  virtualisation.oci-containers.containers = {
    navidrome = {
      autoStart = true;
      image = "docker.io/deluan/navidrome:0.52.5";
      ports = [ "${toString navidromePort}:${toString navidromePort}" ];
      environment = {
        ND_SCANSCHEDULE = "1h";
      };
      volumes = [
        "/etc/navidrome/data:/data"
        "/media/music:/music:ro"
      ];
    };
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

  networking.firewall.allowedTCPPorts = [ navidromePort ];
}
