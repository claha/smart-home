{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.ollama;
in
{
  options.homelab.ollama = {
    enable = lib.mkEnableOption "Ollama LLM server";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.unstable.ollama;
      host = "0.0.0.0";
      openFirewall = true;
    };
  };
}
