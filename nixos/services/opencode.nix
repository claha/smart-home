{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.opencode;
  port = 8199;
in
{
  options.homelab.opencode = {
    enable = lib.mkEnableOption "OpenCode Web Interface (user service via home-manager)";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ port ];
  };
}
