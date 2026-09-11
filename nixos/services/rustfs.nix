{
  config,
  lib,
  ...
}:

let
  cfg = config.homelab.rustfs;
  port = 9000;
in
{
  options.homelab.rustfs = {
    enable = lib.mkEnableOption "RustFS object storage server";
  };

  config = lib.mkIf cfg.enable {
    services.rustfs = {
      enable = true;
      volumes = "/data/rustfs";
      address = ":${toString port}";
      consoleEnable = true;
      consoleAddress = ":9001";
      accessKeyFile = config.age.secrets.rustfs-access-key.path;
      secretKeyFile = config.age.secrets.rustfs-secret-key.path;
    };

    networking.firewall.allowedTCPPorts = [
      port
      9001
    ];
  };
}
