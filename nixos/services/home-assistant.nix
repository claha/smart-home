{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.home-assistant;
in
{
  options.homelab.home-assistant = {
    enable = lib.mkEnableOption "Home Assistant";
  };

  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      package = pkgs.unstable.home-assistant.overrideAttrs (old: {
        doInstallCheck = false;
      });

      extraPackages = ps: [
        ps.isal
        ps.zlib-ng
      ];

      extraComponents = [
        "default_config"
        "google_translate"
        "homeassistant_hardware"
        "homeassistant_sky_connect"
        "ibeacon"
        "met"
        "radio_browser"
        "usb"
        "zha"
      ];

      openFirewall = true;

      config = {
        default_config = { };
        automation = "!include automations.yaml";

        logger = {
          default = "warning";
        };

        homeassistant = {
          name = "Home";
          latitude = "!secret latitude";
          longitude = "!secret longitude";
          unit_system = "metric";
          temperature_unit = "C";
          time_zone = "Europe/Stockholm";
          country = "SE";
          currency = "SEK";
        };
      };
    };
  };
}
