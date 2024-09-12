{ config, pkgs, ... }:

let
  musicAssistantPort = 8095;
  musicAssistantStreamPort = 8097;
  sonosAppCtrlPort = 1400;
in
{
  virtualisation.oci-containers.containers = {
    music-assistant = {
      autoStart = true;
      image = "ghcr.io/music-assistant/server:2.2.3";
      volumes = [
        "/etc/music-assistant/data:/data"
        "/media/music:/media:ro"
      ];
      extraOptions = [ "--network=host" "--privileged" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ musicAssistantPort musicAssistantStreamPort sonosAppCtrlPort ];
}
