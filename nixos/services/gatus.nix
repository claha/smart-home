{ config, pkgs, ... }:

let
  tailscaleDevices = [
    { hostname = "chewbacca"; address = "100.110.122.14"; }
    { hostname = "luffy"; address = "100.118.93.10"; }
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
            url = "icmp://${device.address}";
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
