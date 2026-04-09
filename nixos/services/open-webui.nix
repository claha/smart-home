{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.open-webui;
in
{
  options.homelab.open-webui = {
    enable = lib.mkEnableOption "OpenWebUI";
  };

  config = lib.mkIf cfg.enable {
    services.open-webui = {
      enable = true;
      package = pkgs.unstable.open-webui;
      host = "0.0.0.0";
      openFirewall = true;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "False";
      };
    };
  };
}
