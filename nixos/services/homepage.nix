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
        theme = "dark";
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
                icon = "music-assistant-light";
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
                href = "https://home-assistant.${domain}";
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
                icon = "open-webui-light";
              };
            }
            {
              It-Tools = {
                href = "https://ittools.${domain}";
                icon = "it-tools-light";
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
                icon = "beszel-light";
              };
            }
          ];
        }
        {
          Tools = [
            {
              "Pocket ID" = {
                href = "https://id.${domain}";
                icon = "pocket-id-light";
              };
            }
            {
              RustFS = {
                href = "https://rustfs.${domain}";
                icon = "rustfs";
              };
            }
            {
              "OpenCode (Luffy)" = {
                href = "https://opencode-luffy.${domain}";
                icon = "opencode-dark";
              };
            }
            {
              "OpenCode (Eren)" = {
                href = "https://opencode-eren.${domain}";
                icon = "opencode-dark";
              };
            }
            {
              "OpenCode (Naruto)" = {
                href = "https://opencode-naruto.${domain}";
                icon = "opencode-dark";
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
                  icon = "github-light";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
