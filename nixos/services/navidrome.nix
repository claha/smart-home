{ config, pkgs, ... }:

{
  services.navidrome = {
    enable = true;
    package = pkgs.unstable.navidrome;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/media/music";
      ScanSchedule = "@every 1h";
    };
    openFirewall = true;
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
}
