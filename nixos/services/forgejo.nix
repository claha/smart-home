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
          # Run Forgejo's built-in SSH server instead of relying on the system
          # sshd. Without this Forgejo never opens SSH_LISTEN_PORT.
          START_SSH_SERVER = true;
          # Separate name for SSH so LAN clients (blocky rewrites *.${domain} to
          # luffy) reach eren directly on 2222. Public DNS wildcards this name
          # to the WAN IP, where the router forwards 2222 to eren.
          SSH_DOMAIN = "git.${domain}";
          # The built-in SSH server only accepts this username (it defaults to
          # RUN_USER, i.e. "forgejo") and it is also the user shown in clone
          # URLs. Set it to "git" so URLs/clients use git@... while the system
          # user stays "forgejo" (which owns /data/forgejo).
          BUILTIN_SSH_SERVER_USER = "git";
          # Forgejo's built-in SSH server binds 2222 because the system sshd
          # already owns port 22 on the host.
          SSH_LISTEN_PORT = 2222;
          SSH_PORT = 2222;
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

    networking.firewall.allowedTCPPorts = [
      port
      2222
    ];
  };
}
