{ config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    host = "0.0.0.0";
    openFirewall = true;
  };

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
}
