{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.memos;
  port = 5230;
in
{
  options.homelab.memos = {
    enable = lib.mkEnableOption "Memos note-taking";
  };

  config = lib.mkIf cfg.enable {
    services.memos = {
      enable = true;
      package = pkgs.unstable.memos;
      settings = {
        MEMOS_PORT = toString port;
        MEMOS_ADDR = "0.0.0.0";
        MEMOS_INSTANCE_URL = "https://memos.hallstrom.duckdns.org";
      };
    };

    # Temporary fixes
    systemd.services.memos = {
      serviceConfig = {
        PrivateUsers = lib.mkForce false;
        MemoryDenyWriteExecute = lib.mkForce false;
        SystemCallFilter = lib.mkForce [
          "@system-service"
          "~@privileged"
          "~@resources"
          "~@mount"
        ];
        ExecStart = lib.mkForce "${lib.getExe config.services.memos.package} --data ${config.services.memos.dataDir}";
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
