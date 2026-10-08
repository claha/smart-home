{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.audiobookshelf;
  # nixpkgs sets WorkingDirectory to /var/lib/<dataDir>; Audiobookshelf
  # keeps its own nightly backups in <workingDir>/metadata/backups.
  backupsDir = "/var/lib/${config.services.audiobookshelf.dataDir}/metadata/backups";
in
{
  options.homelab.audiobookshelf = {
    enable = lib.mkEnableOption "Audiobookshelf";
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      package = pkgs.unstable.audiobookshelf;
      host = "0.0.0.0";
      port = 13378;
      openFirewall = true;
    };

    services.restic.backups.audiobookshelf = {
      initialize = true;
      paths = [ backupsDir ];
      repository = "s3:https://rustfs.hallstrom.duckdns.org/backups/audiobookshelf";
      environmentFile = config.age.secrets.restic-s3.path;
      passwordFile = config.age.secrets.restic-password.path;
      timerConfig = {
        OnCalendar = "03:00";
        Persistent = true;
        RandomizedDelaySec = "10m";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };
}
