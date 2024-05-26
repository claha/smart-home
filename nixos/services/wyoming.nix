{ config, pkgs, ... }:

let
in
{
  services.wyoming.piper.servers = {
    "en" = {
      enable = true;
      voice = "en-us-lessac-low";
      uri = "tcp://0.0.0.0:10200";
    };
  };

  services.wyoming.faster-whisper.servers = {
    "en" = {
      enable = true;
      model = "tiny-int8";
      language = "en";
      uri = "tcp://0.0.0.0:10300";
      device = "cpu";
    };
  };

  networking.firewall.allowedTCPPorts = [ 10200 10300 ];
}
