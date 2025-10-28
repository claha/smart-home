{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.jellyfin;
  musicAssistantPort = 8095;
  musicAssistantStreamPort = 8097;
  sonosAppCtrlPort = 1400;
in
{
  options.homelab.music-assistant = {
    enable = lib.mkEnableOption "Music Assistant server";
  };

  config = lib.mkIf cfg.enable {
    services.music-assistant = {
      enable = true;
      package = pkgs.unstable.music-assistant;
      providers = [
        "builtin"
        "filesystem_local"
        "sonos"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      musicAssistantPort
      musicAssistantStreamPort
      sonosAppCtrlPort
    ];
  };
}
