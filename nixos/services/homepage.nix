{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.homepage;
  domain = config.homelab.domain;
in
{
  options.homelab.homepage = {
    enable = lib.mkEnableOption "Homepage";
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "homepage.${domain}";

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
          ];
        }
        {
          Media = [
            {
              Jellyfin = {
                href = "https://jellyfin.${domain}";
                icon = "jellyfin";
              };
            }
            {
              Pinchflat = {
                href = "https://pinchflat.${domain}";
                icon = "pinchflat";
              };
            }
            {
              Audiobookshelf = {
                href = "https://audiobookshelf.${domain}";
                icon = "audiobookshelf";
              };
            }
            {
              "Music-Assistant" = {
                href = "https://musicassistant.${domain}";
                icon = "music-assistant";
              };
            }
            {
              Immich = {
                href = "https://immich.${domain}";
                icon = "immich";
              };
            }
          ];
        }
        {
          "Home" = [
            {
              "Home-Assistant" = {
                href = "https://homeassistant.${domain}";
                icon = "home-assistant";
              };
            }
            {
              Mealie = {
                href = "https://mealie.${domain}";
                icon = "mealie";
              };
            }
          ];
        }
        {
          Productivity = [
            {
              Vikunja = {
                href = "https://vikunja.${domain}";
                icon = "vikunja";
              };
            }
            {
              Karakeep = {
                href = "https://karakeep.${domain}";
                icon = "karakeep";
              };
            }
            {
              Memos = {
                href = "https://memos.${domain}";
                icon = "memos";
              };
            }
            {
              "Open-WebUI" = {
                href = "https://open-webui.${domain}";
                icon = "open-webui";
              };
            }
            {
              It-Tools = {
                href = "https://ittools.${domain}";
                icon = "it-tools";
              };
            }
          ];
        }
        {
          Monitor = [
            {
              "Gatus" = {
                href = "https://gatus.${domain}";
                icon = "gatus";
              };
            }
            {
              "Beszel" = {
                href = "https://beszel.${domain}";
                icon = "beszel";
              };
            }
          ];
        }
        {
          Tools = [
            {
              "Pocket ID" = {
                href = "https://id.${domain}";
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
