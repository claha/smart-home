{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:

let
  cfg = config.homelab.traefik;

  inherit (lib)
    mkMerge
    mkIf
    mkOption
    types
    mapAttrs'
    ;

  domain = "hallstrom.duckdns.org";

  naruto = hostConfig.hosts.naruto.ip.lan;
  luffy = hostConfig.hosts.luffy.ip.lan;
  eren = hostConfig.hosts.eren.ip.lan;
  rpi4 = hostConfig.hosts.rpi4.ip.lan;

  services = {
    beszel = "http://${naruto}:8090";
    gatus = "http://${naruto}:8080";
    id = "http://${naruto}:1411";
    ittools = "http://${naruto}:8023";
    karakeep = "http://${naruto}:3000";
    mealie = "http://${naruto}:9000";
    ntfy = "http://${naruto}:2586";
    vikunja = "http://${naruto}:3456";

    audiobookshelf = "http://${luffy}:13378";
    homepage = "http://${luffy}:8082";
    jellyfin = "http://${luffy}:8096";
    musicassistant = "http://${luffy}:8095";
    pinchflat = "http://${luffy}:8945";

    immich = "http://${eren}:2283";
    memos = "http://${eren}:5230";
    openwebui = "http://${eren}:8080";

    homeassistant = "http://${rpi4}:8123";
  };

  servicesWithMiddleware = {
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

  options.homelab.traefik = {
    enable = lib.mkEnableOption "Traefik reverse proxy";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
