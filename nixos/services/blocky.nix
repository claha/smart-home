{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:

let
  cfg = config.homelab.blocky;
  luffy = hostConfig.hosts.luffy;
in
{
  options.homelab.blocky = {
    enable = lib.mkEnableOption "Blocky DNS proxy and ad-blocker";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.blocky ];
    services.blocky = {
      enable = true;
      package = pkgs.blocky;
      # enableConfigCheck = true;
      settings = {
        ports = {
          dns = 53;
          http = 4000;
        };

        upstreams = {
          groups = {
            default = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          };
        };

        bootstrapDns = [
          "tcp+udp:1.1.1.1"
          "tcp+udp:1.0.0.1"
        ];

        customDNS = {
          mapping = {
            "hallstrom.duckdns.org" = "${luffy.ip.tailscale},${luffy.ip.lan}";
          };
        };

        caching = {
          minTime = "5m";
          maxTime = "1h";
          prefetching = true;
          cacheTimeNegative = "30m";
        };

        blocking = {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/pro.txt"
            ];
            malware = [
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/tif.txt"
            ];
          };
          clientGroupsBlock = {
            default = [
              "ads"
              "malware"
            ];
          };
          blockType = "zeroIP";
        };
      };
    };

    networking.nameservers = [ "127.0.0.1" ];

    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.firewall.allowedTCPPorts = [
      53
      4000
    ];
  };
}
