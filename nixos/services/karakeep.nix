{
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:

let
  cfg = config.homelab.karakeep;
  port = 3000;
  eren = hostConfig.hosts.eren;
in
{
  options.homelab.karakeep = {
    enable = lib.mkEnableOption "Karakeep organizer";
  };

  config = lib.mkIf cfg.enable {
    services.karakeep = {
      enable = true;
      package = pkgs.unstable.karakeep;
      extraEnvironment = {
        CRAWLER_VIDEO_DOWNLOAD = "true";
        CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = "-1";
        OLLAMA_BASE_URL = "http://${eren.ip.lan}:11434";
        INFERENCE_TEXT_MODEL = "llama3.2:1b";
        INFERENCE_IMAGE_MODEL = "llava-phi3";
        INFERENCE_CONTEXT_LENGTH = "4096";
        OAUTH_WELLKNOWN_URL = "https://id.hallstrom.duckdns.org/.well-known/openid-configuration";
        OAUTH_PROVIDER_NAME = "Pocket-ID";
        NEXTAUTH_URL = "https://karakeep.hallstrom.duckdns.org";
        OAUTH_ALLOW_DANGEROUS_EMAIL_ACCOUNT_LINKING = "true";
        DISABLE_PASSWORD_AUTH = "true";
        DISABLE_SIGNUPS = "true";
      };
      environmentFile = config.age.secrets.karakeep.path;
    };
    networking.firewall.allowedTCPPorts = [ port ];
  };
}
