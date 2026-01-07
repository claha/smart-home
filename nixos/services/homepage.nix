{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.homepage;
in
{
  options.homelab.homepage = {
    enable = lib.mkEnableOption "Homepage";
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "homepage.hallstrom.duckdns.org";

      settings = {
        language = "en";
      };

      widgets = [
        {
          resources = {
            cpu = false;
            memory = false;
            disk = false;
            cputemp = false;
            uptime = false;
            units = "metric";
          };
        }
      ];

      services = [
        {
          Network = [
            {
              Router = {
                href = "http://192.168.1.1";
                icon = "asus-router";
              };
            }
            {
              Switch = {
                href = "https://192.168.1.50";
                icon = "ruckus-unleashed";
              };
            }
            {
              "Access Point" = {
                href = "https://192.168.1.67";
                icon = "ruckus-unleashed";
              };
            }
            {
              "Pi-hole" = {
                href = "https://pihole.hallstrom.duckdns.org";
                icon = "pi-hole";
              };
            }
          ];
        }
        {
          Media = [
            {
              Jellyfin = {
                href = "https://jellyfin.hallstrom.duckdns.org";
                icon = "jellyfin";
              };
            }
            {
              Pinchflat = {
                href = "https://pinchflat.hallstrom.duckdns.org";
                icon = "pinchflat";
              };
            }
            {
              Audiobookshelf = {
                href = "https://audiobookshelf.hallstrom.duckdns.org";
                icon = "audiobookshelf";
              };
            }
            {
              "Music-Assistant" = {
                href = "https://musicassistant.hallstrom.duckdns.org";
                icon = "music-assistant";
              };
            }
            {
              Immich = {
                href = "https://immich.hallstrom.duckdns.org";
                icon = "immich";
              };
            }
          ];
        }
        {
          "Home" = [
            {
              "Home-Assistant" = {
                href = "https://homeassistant.hallstrom.duckdns.org";
                icon = "home-assistant";
              };
            }
            {
              Mealie = {
                href = "https://mealie.hallstrom.duckdns.org";
                icon = "mealie";
              };
            }
          ];
        }
        {
          Productivity = [
            {
              Vikunja = {
                href = "https://vikunja.hallstrom.duckdns.org";
                icon = "vikunja";
              };
            }
            {
              Karakeep = {
                href = "https://karakeep.hallstrom.duckdns.org";
                icon = "karakeep";
              };
            }
            {
              Open-Webui = {
                href = "https://openwebui.hallstrom.duckdns.org";
                icon = "open-webui";
              };
            }
            {
              It-Tools = {
                href = "https://ittools.hallstrom.duckdns.org";
                icon = "it-tools";
              };
            }
          ];
        }
        {
          Monitor = [
            {
              "Gatus" = {
                href = "https://gatus.hallstrom.duckdns.org";
                icon = "gatus";
              };
            }
            {
              "Beszel" = {
                href = "https://beszel.hallstrom.duckdns.org";
                icon = "beszel";
              };
            }
          ];
        }
        {
          Tools = [
            {
              "Pocket ID" = {
                href = "https://id.hallstrom.duckdns.org";
                icon = "pocket-id";
              };
            }
          ];
        }
      ];

      bookmarks = [
        {
          Bookmarks = [
            {
              "GitHub" = [
                {
                  href = "https://github.com/claha";
                  icon = "github";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
