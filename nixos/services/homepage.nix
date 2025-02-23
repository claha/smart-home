{ config, pkgs, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;

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
        ];
      }
      {
        Media = [
          {
            Navidrome = {
              href = "https://navidrome.hallstrom.duckdns.org";
              icon = "navidrome";
            };
          }
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
        "Home-Automation" = [
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
        ];
      }
      {
        Monitor = [
          {
            "Gatus (RPi 3)" = {
              href = "http://192.168.1.24:8080";
              icon = "gatus";
            };
          }
          {
            "Gatus (Internal)" = {
              href = "https://gatus.hallstrom.duckdns.org";
              icon = "gatus";
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
