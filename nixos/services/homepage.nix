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
            "Pi-hole (primary)" = {
              href = "https://192.168.1.24/admin";
              icon = "pi-hole";
            };
          }
          {
            "Pi-hole (secondary)" = {
              href = "https://192.168.1.73/admin";
              icon = "pi-hole";
            };
          }
        ];
      }
      {
        Media = [
          {
            Navidrome = {
              href = "https://navidrome.media.hallstrom.duckdns.org";
              icon = "navidrome";
            };
          }
          {
            Jellyfin = {
              href = "https://jellyfin.media.hallstrom.duckdns.org";
              icon = "jellyfin";
            };
          }
          {
            Audiobookshelf = {
              href = "https://audiobookshelf.media.hallstrom.duckdns.org";
              icon = "audiobookshelf";
            };
          }
          {
            "Music-Assistant" = {
              href = "https://music.media.hallstrom.duckdns.org";
              icon = "https://avatars.githubusercontent.com/u/71128003?s=200&v=4";
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
            "Gatus (OCI 0)" = {
              href = "http://100.117.82.95:8080";
              icon = "gatus";
            };
          }
          {
            "Gatus (OCI 1)" = {
              href = "http://100.99.164.134:8080";
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
