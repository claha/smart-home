{ config, pkgs, ... }:

let
  glancesPort = 61208;
in
{
  environment.systemPackages = with pkgs; [
    glances
  ];

  systemd.services."glances" = {
    script = "glances --webserver --disable-webui";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = "root";
      Restart = "on-abort";
      RemainAfterExit = "yes";
    };
    path = [
      pkgs.glances
    ];
  };

  networking.firewall.allowedTCPPorts = [ glancesPort ];
}
