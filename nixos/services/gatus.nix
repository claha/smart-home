{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:

let
  cfg = config.homelab.gatus;
  domain = config.homelab.domain;
  hosts = lib.filterAttrs (name: host: host.user != "claes") hostConfig.hosts;

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
      name = domain;
      group = "Domain";
      url = "https://${domain}";
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
      url = "https://audiobookshelf.${domain}/healthcheck";
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
      url = "https://jellyfin.${domain}/health";
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
            url = "https://ntfy.${domain}";
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
