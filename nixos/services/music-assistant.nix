{ config, pkgs, ... }:

let
  musicAssistantPort = 8095;
  musicAssistantStreamPort = 8097;
  sonosAppCtrlPort = 1400;
in
{
  services.music-assistant = {
    enable = true;
    package = pkgs.unstable.music-assistant;
    providers = [
      "builtin"
      "filesystem_local"
      "sonos"
    ];
  };

  networking.firewall.allowedTCPPorts = [ musicAssistantPort musicAssistantStreamPort sonosAppCtrlPort ];
}
