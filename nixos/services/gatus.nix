{ config, pkgs, ... }:

let
  tailscaleDevices = [
    { hostname = "chewbacca"; tailscaleIp = "100.110.122.14"; }
    { hostname = "luffy"; tailscaleIp = "100.118.93.10"; }
    { hostname = "eren"; tailscaleIp = "100.77.170.28"; }
    { hostname = "rpi4"; tailscaleIp = "100.74.114.39"; }
    { hostname = "rpi3"; tailscaleIp = "100.95.2.1"; }
  ];

  tailscaleEndpoints = map
    (device: {
      name = device.hostname;
      group = "Tailscale";
      url = "icmp://${device.tailscaleIp}";
      interval = "5m";
      conditions = [
        "[CONNECTED] == true"
      ];
      alerts = [
        {
          type = "ntfy";
        }
      ];
    })
    tailscaleDevices;

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
in
{
  services.gatus = {
    enable = true;
    openFirewall = true;
    settings = {
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
      endpoints = tailscaleEndpoints ++ domainEndpoints;
    };
  };

  systemd.services.gatus.serviceConfig.AmbientCapabilities = "CAP_NET_RAW";
}
