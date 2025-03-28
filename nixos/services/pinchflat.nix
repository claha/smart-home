{ config, pkgs, ... }:

let
  pinchflatPort = 8945;
in
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      flags = [ "--all" "--volumes" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/pinchflat 0770 pinchflat jellyfin -"
    "d /var/lib/pinchflat/config 0770 pinchflat jellyfin -"
    "d /media/youtube 0770 jellyfin jellyfin -"
  ];

  users.users.pinchflat = {
    isSystemUser = true;
    group = "pinchflat";
    extraGroups = [ "jellyfin" ];
  };
  users.groups.pinchflat = { };

  virtualisation.oci-containers = {
    backend = "docker";
    containers.pinchflat = {
      image = "ghcr.io/kieraneglin/pinchflat:v2025.3.17";
      environment = {
        TZ = config.time.timeZone;
      };
      ports = [
        "8945:8945/tcp"
      ];
      volumes = [
        "/var/lib/pinchflat/config:/config:rw"
        "/media/youtube:/downloads:rw"
      ];
      log-driver = "journald";
      autoStart = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 8945 ];
}
