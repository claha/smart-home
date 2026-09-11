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
      name = "Blocky Blocklists";
      group = "Service";
      url = "http://localhost:4000/api/stats";
      interval = "30m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].lists.denylist.ads > 0"
        "[BODY].lists.denylist.malware > 0"
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
    {
      name = "Immich";
      group = "Service";
      url = "https://immich.${domain}/api/server/ping";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].res == pong"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "RustFS";
      group = "Service";
      url = "https://rustfs.${domain}/health/ready";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].ready == true"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Pocket ID";
      group = "Service";
      url = "https://id.${domain}/healthz";
      interval = "15m";
      conditions = [
        "[STATUS] == 204"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Beszel";
      group = "Service";
      url = "https://beszel.${domain}/api/health";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].code == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Ntfy";
      group = "Service";
      url = "https://ntfy.${domain}/v1/health";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].healthy == true"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Open-WebUI";
      group = "Service";
      url = "https://open-webui.${domain}/health";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].status == true"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Memos";
      group = "Service";
      url = "https://memos.${domain}/healthz";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Karakeep";
      group = "Service";
      url = "https://karakeep.${domain}/api/health";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].status == ok"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Vikunja";
      group = "Service";
      url = "https://vikunja.${domain}/api/v1/info";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Gatus";
      group = "Service";
      url = "https://gatus.${domain}/health";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
        "[BODY].status == UP"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      # /api/ requires a token, so 401 means the API stack is up and enforcing auth
      name = "Home-Assistant";
      group = "Service";
      url = "https://home-assistant.${domain}/api/";
      interval = "15m";
      conditions = [
        "[STATUS] == 401"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Homepage";
      group = "Service";
      url = "https://homepage.${domain}/";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "IT-Tools";
      group = "Service";
      url = "https://ittools.${domain}/";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Music-Assistant";
      group = "Service";
      url = "https://musicassistant.${domain}/";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Pinchflat";
      group = "Service";
      url = "https://pinchflat.${domain}/";
      interval = "15m";
      conditions = [
        "[STATUS] == 200"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    }
    {
      name = "Traefik";
      group = "Service";
      url = "http://${hostConfig.hosts.luffy.ip.lan}:8083/ping";
      interval = "5m";
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
