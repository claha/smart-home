{ config, lib, ... }:
let
  inherit (lib)
    mkMerge
    mkIf
    mkOption
    types
    mapAttrs'
    ;

  domain = "hallstrom.duckdns.org";

  services = {
    homepage = "http://0.0.0.0:8082";
    audiobookshelf = "http://0.0.0.0:13378";
    jellyfin = "http://0.0.0.0:8096";
    pinchflat = "http://0.0.0.0:8945";
    musicassistant = "http://0.0.0.0:8095";
    homeassistant = "http://192.168.1.173:8123";
    pihole = "http://192.168.1.24";
    gatus = "http://192.168.1.49:8080";
    netalertx = "http://192.168.1.24:20211";
    vikunja = "http://192.168.1.49:3456";
    mealie = "http://192.168.1.49:9000";
    karakeep = "http://192.168.1.49:3000";
    ntfy = "http://192.168.1.49:2586";
    beszel = "http://192.168.1.49:8090";
    openwebui = "http://192.168.1.228:8080";
    ittools = "http://192.168.1.49:8023";
    id = "http://192.168.1.49:1411";
  };

  servicesWithMiddleware = {
    pihole = [ "sslheader" ];
    ntfy = [ "websocketheader" ];
  };

  routers =
    mapAttrs' (name: url: {
      name = name;
      value = {
        rule = "Host(`${name}.${domain}`)";
        service = name;
      }
      // lib.optionalAttrs (servicesWithMiddleware ? ${name}) {
        middlewares = servicesWithMiddleware.${name};
      };
    }) services
    // {
      # Add the internal Traefik dashboard router manually
      traefik = {
        rule = "Host(`traefik.${domain}`)";
        service = "api@internal";
      };
    };

  # Define services for each backend
  traefikServices = mapAttrs' (name: url: {
    name = name;
    value.loadBalancer.servers = [ { url = url; } ];
  }) services;
in
{
  imports = [
    ../modules/duckdns.nix
  ];

  services.traefik = {
    enable = true;
    environmentFiles = [ config.age.secrets.duckdns-token.path ];
    staticConfigOptions = {
      global = {
        checkNewVersion = true;
        sendAnonymousUsage = false;
      };

      log = {
        level = "INFO";
        filepath = "/var/lib/traefik/traefik.log";
      };

      accessLog.filePath = "/var/lib/traefik/access.log";

      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          http = {
            middlewares = [ "sslheader@file" ];
            tls = {
              certResolver = "letsencrypt";
              domains = [
                {
                  main = "${domain}";
                  sans = [ "*.${domain}" ];
                }
              ];
            };
          };
        };
      };

      api = {
        insecure = false;
        dashboard = true;
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "hallstrom.claes@gmail.com";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge.provider = "duckdns";
      };
    };

    dynamicConfigOptions = {
      http = {
        routers = routers;

        middlewares = {
          sslheader = {
            headers.customRequestHeaders."X-Forwarded-Proto" = "https";
          };
          websocketheader = {
            headers.customRequestHeaders = {
              Connection = "upgrade";
              Upgrade = "websocket";
            };
          };
        };

        services = traefikServices;
      };
    };
  };

  services.duckdns = {
    enable = true;
    domains = [ "hallstrom" ];
    environmentFiles = [ config.age.secrets.duckdns-token.path ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
  };
}
