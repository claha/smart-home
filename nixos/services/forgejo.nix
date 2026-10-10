{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.forgejo;
  domain = config.homelab.domain;
  port = 8020;
in
{
  options.homelab.forgejo = {
    enable = lib.mkEnableOption "Forgejo git forge";
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /data/forgejo 0750 ${config.services.forgejo.user} ${config.services.forgejo.group} - -"
      "d /data/forgejo/.ssh 0700 ${config.services.forgejo.user} ${config.services.forgejo.group} - -"
    ];

    services.forgejo = {
      enable = true;
      package = pkgs.forgejo-lts;
      stateDir = "/data/forgejo";
      database = {
        type = "sqlite3";
        createDatabase = true;
      };
      settings = {
        server = {
          PROTOCOL = "http";
          HTTP_ADDR = "0.0.0.0";
          HTTP_PORT = port;
          DOMAIN = "forgejo.${domain}";
          ROOT_URL = "https://forgejo.${domain}";
          DISABLE_SSH = false;
          SSH_PORT = 22;
        };
        service = {
          DISABLE_REGISTRATION = false;
          REQUIRE_SIGNIN_VIEW = false;
          ENABLE_INTERNAL_SIGNIN = true;
        };
        session = {
          COOKIE_SECURE = true;
        };
        log = {
          LEVEL = "Info";
          ROOT_PATH = "${config.services.forgejo.stateDir}/log";
        };
        openid = {
          ENABLE_OPENID_SIGNIN = true;
          ENABLE_OPENID_SIGNUP = true;
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          USERNAME = "nickname";
          ACCOUNT_LINKING = "auto";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
