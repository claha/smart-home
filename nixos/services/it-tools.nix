{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.it-tools;
  port = 8023;
in
{
  options.homelab.it-tools = {
    enable = lib.mkEnableOption "IT-Tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      static-web-server
      it-tools
    ];

    systemd.services.it-tools = {
      description = "Serve it-tools static site";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.static-web-server}/bin/static-web-server --root ${pkgs.it-tools}/lib --port ${toString port}";
        DynamicUser = true;
        Restart = "always";
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
