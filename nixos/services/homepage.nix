{ config, pkgs, ... }:
{
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
              icon = "https://avatars.githubusercontent.com/u/66272752?s=200&v=4";
            };
          }
          {
            "Access Point" = {
              href = "https://10.0.10.101";
              icon = "https://avatars.githubusercontent.com/u/66272752?s=200&v=4";
            };
          }
          {
            "Pi-hole" = {
              href = "https://pihole.hallstrom.duckdns.org";
              icon = "pi-hole";
            };
          }
          {
            "NetAlertX" = {
              href = "https://netalertx.hallstrom.duckdns.org";
              icon = "netalertx";
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
            Zigbee2Mqtt = {
              href = "http://192.168.1.180:8080";
              icon = "zigbee2mqtt";
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
            Nextcloud = {
              href = "https://nextcloud.hallstrom.duckdns.org";
              icon = "nextcloud";
            };
          }
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
    ];

    bookmarks = [
      {
        Bookmarks = [
          {
            "Smart-Home" = [
              {
                href = "https://github.com/claha/smart-home";
                icon = "mdi-home";
              }
            ];
          }
          {
            dotfiles = [
              {
                href = "https://github.com/claha/dotfiles";
                icon = "mdi-file";
              }
            ];
          }
        ];
      }
    ];
  };
}
