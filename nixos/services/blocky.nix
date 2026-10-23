{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:

let
  cfg = config.homelab.blocky;
  domain = config.homelab.domain;
  luffy = hostConfig.hosts.luffy;
  eren = hostConfig.hosts.eren;
in
{
  options.homelab.blocky = {
    enable = lib.mkEnableOption "Blocky DNS proxy and ad-blocker";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.blocky ];
    services.blocky = {
      enable = true;
      package = pkgs.unstable.blocky;
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
            "${domain}" = "${luffy.ip.tailscale},${luffy.ip.lan}";
            # Forgejo's SSH server lives on eren; more specific entries win in
            # blocky, so this name bypasses the catch-all above.
            "git.${domain}" = "${eren.ip.lan},${eren.ip.tailscale}";
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
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
            ];
            malware = [
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif.txt"
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

        statistics = {
          enable = true;
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
