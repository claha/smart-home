{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bambuddy;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    types
    ;

  # systemd environment values must be strings, and pydantic accepts "true"
  # rather than Nix's "1" for booleans.
  renderEnvValue =
    value: if lib.isBool value then (if value then "true" else "false") else toString value;
in
{
  options.services.bambuddy = {
    enable = mkEnableOption "BamBuddy, a self-hosted Bambu Lab print archive";

    package = mkPackageOption pkgs "bambuddy" { };

    user = mkOption {
      type = types.str;
      default = "bambuddy";
      description = "User account under which BamBuddy runs.";
    };

    group = mkOption {
      type = types.str;
      default = "bambuddy";
      description = "Group under which BamBuddy runs.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/bambuddy";
      description = ''
        Directory holding all persistent state: the SQLite database (or the
        credentials for an external PostgreSQL, see
        {option}`services.bambuddy.settings`), the print archive, plate
        calibration data and scheduled backups.

        BamBuddy itself lives in the read-only Nix store, so this is the only
        writable location besides {option}`services.bambuddy.logDir`.
      '';
    };

    logDir = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/logs";
      defaultText = literalExpression ''"''${config.services.bambuddy.dataDir}/logs"'';
      description = ''
        Directory for `bambuddy.log` and its rotations. Only used when file
        logging is enabled, which is the default.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address the web interface listens on.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port the web interface listens on.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open {option}`services.bambuddy.port` in the firewall.";
    };

    settings = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          bool
          int
          float
          str
        ]);
      default = { };
      example = {
        LOG_LEVEL = "DEBUG";
        BAMBUDDY_EXTERNAL_ROOTS = "/mnt/nas/3d-prints";
        DATABASE_URL = "postgresql+asyncpg://bambuddy:secret@localhost:5432/bambuddy";
      };
      description = ''
        Environment variables passed to BamBuddy, covering everything in
        `.env.example` upstream: logging, external library folders, the MFA
        encryption key, outbound notification settings and so on. See
        <https://wiki.bambuddy.cool/getting-started/installation/#environment-variables>.

        {option}`services.bambuddy.dataDir`,
        {option}`services.bambuddy.logDir` and
        {option}`services.bambuddy.port` are always set from their options and
        win over values given here.

        Prefer {option}`services.bambuddy.environmentFile` for secrets.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/bambuddy.env";
      description = ''
        File with additional environment variables in `KEY=value` form,
        read by systemd before the service starts. Typically used for secrets
        such as `MFA_ENCRYPTION_KEY`, credentials inside `DATABASE_URL` or the
        `BAMBUDDY_OIDC_CLIENT_SECRET` of a declarative OIDC provider.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--proxy-headers" ];
      description = "Extra command line arguments passed to uvicorn.";
    };

    extraReadWritePaths = mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = [ "/mnt/nas/bambuddy-backups" ];
      description = ''
        Additional paths BamBuddy may write to, for example a NAS mount used as
        an external library folder or as the destination of scheduled backups.
        {option}`services.bambuddy.dataDir` and
        {option}`services.bambuddy.logDir` are always writable.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      description = "BamBuddy service user";
    };

    users.groups.${cfg.group} = { };

    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.logDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.bambuddy = {
      description = "BamBuddy print archive";
      documentation = [ "https://wiki.bambuddy.cool/getting-started/installation/" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = {
        DATA_DIR = toString cfg.dataDir;
        LOG_DIR = toString cfg.logDir;
        PORT = toString cfg.port;
        TZ = config.time.timeZone;
      }
      // lib.mapAttrs (_: renderEnvValue) cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;

        # --loop asyncio: uvloop truncates virtual printer FTP uploads on slow
        # storage (#1896).
        # --timeout-graceful-shutdown: uvicorn otherwise waits forever for an
        # in-flight MJPEG camera stream and systemd has to SIGKILL the service,
        # skipping the SQLite WAL checkpoint and the virtual printer teardown.
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "--host"
            cfg.listenAddress
            "--port"
            (toString cfg.port)
            "--loop"
            "asyncio"
            "--timeout-graceful-shutdown"
            "5"
          ]
          ++ cfg.extraArgs
        );

        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;

        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 30;

        # Hardening. The service only needs to write to its own directories.
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        # /home is hidden by default, but made visible (read-only) when the data
        # directory lives there, since ReadWritePaths overrides it for dataDir.
        ProtectHome = if lib.hasPrefix "/home/" (toString cfg.dataDir) then "read-only" else true;
        ReadWritePaths = [
          cfg.dataDir
          cfg.logDir
        ]
        ++ cfg.extraReadWritePaths;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };
  };
}
