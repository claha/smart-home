{ config, pkgs, ... }:

let
  tailscaleDevices = [
    { hostname = "chewbacca"; tailscaleIp = "100.110.122.14"; }
    { hostname = "luffy"; tailscaleIp = "100.118.93.10"; }
    { hostname = "eren"; tailscaleIp = "100.77.170.28"; }
    { hostname = "rpi4"; tailscaleIp = "100.74.114.39"; }
    { hostname = "rpi3"; tailscaleIp = "100.95.2.1"; }
  ];
in
{
  services.gatus = {
    enable = true;
    openFirewall = true;
    settings = {
      endpoints = map
        (device:
          {
            name = device.hostname;
            group = "Tailscale";
            url = "icmp://${device.tailscaleIp}";
            interval = "5m";
            conditions = [
              "[CONNECTED] == true"
            ];
          }
        )
        tailscaleDevices;
    };
  };

  systemd.services.gatus.serviceConfig.AmbientCapabilities = "CAP_NET_RAW";
}
