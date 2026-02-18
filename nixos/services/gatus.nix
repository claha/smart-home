{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:

let
  cfg = config.homelab.gatus;
  hosts = hostConfig.hosts;

  tailscaleEndpoints = lib.mapAttrsToList (name: host: {
    name = name;
    group = "Tailscale";
    url = "icmp://${host.ip.tailscale}";
    interval = "5m";
    conditions = [
      "[CONNECTED] == true"
    ];
    alerts = [
      {
        type = "ntfy";
      }
    ];
  }) hosts;

  lanEndpoints = lib.mapAttrsToList (name: host: {
    name = name;
    group = "LAN";
    url = "icmp://${host.ip.lan}";
    interval = "5m";
    conditions = [
      "[CONNECTED] == true"
    ];
    alerts = [
      {
        type = "ntfy";
      }
    ];
  }) hosts;

  domainEndpoints = [
    {
      name = "hallstrom.duckdns.org";
      group = "Domain";
      url = "https://hallstrom.duckdns.org";
      interval = "1h";
      conditions = [
        "[CERTIFICATE_EXPIRATION] > 240h"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
  ];

  serviceEndpoints = [
    {
      name = "Audiobookshelf";
      group = "Service";
      url = "https://audiobookshelf.hallstrom.duckdns.org/healthcheck";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY] == OK"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Jellyfin";
      group = "Service";
      url = "https://jellyfin.hallstrom.duckdns.org/health";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY] == Healthy"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
  ];
in
{
  options.homelab.gatus = {
    enable = lib.mkEnableOption "Gatus status page";
  };

  config = lib.mkIf cfg.enable {
    services.gatus = {
      enable = true;
      openFirewall = true;
      settings = {
        #      storage = {
        #       type = "sqlite";
        #      path = "/var/lib/gatus/data/data.db";
        #   };
        alerting = {
          ntfy = {
            url = "https://ntfy.hallstrom.duckdns.org";
            topic = "gatus";
            priority = 3;
            default-alert = {
              enabled = true;
              failure-threshold = 3;
              success-threshold = 3;
              send-on-resolved = true;
            };
          };
        };
        endpoints = tailscaleEndpoints ++ lanEndpoints ++ domainEndpoints ++ serviceEndpoints;
      };
    };

    systemd.services.gatus.serviceConfig.AmbientCapabilities = "CAP_NET_RAW";
  };
}
