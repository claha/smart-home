{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.wyoming;
in
{
  options.homelab.wyoming = {
    enable = lib.mkEnableOption "Wyoming voice services (Piper TTS, Whisper STT, OpenWakeWord)";
  };

  config = lib.mkIf cfg.enable {
    services.wyoming.piper = {
      package = pkgs.unstable.wyoming-piper;
      servers = {
        "en" = {
          enable = true;
          voice = "en-us-lessac-low";
          uri = "tcp://0.0.0.0:10200";
        };
      };
    };

    services.wyoming.faster-whisper = {
      package = pkgs.unstable.wyoming-faster-whisper;
      servers = {
        "en" = {
          enable = true;
          model = "tiny-int8";
          language = "en";
          uri = "tcp://0.0.0.0:10300";
          device = "cpu";
        };
      };
    };

    services.wyoming.openwakeword = {
      enable = true;
      package = pkgs.unstable.wyoming-openwakeword;
      uri = "tcp://0.0.0.0:10400";
      preloadModels = [
        "ok_nabu"
        "hey_jarvis"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      10200
      10300
      10400
    ];
  };
}
