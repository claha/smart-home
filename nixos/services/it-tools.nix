{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    static-web-server
    it-tools
  ];

  systemd.services.it-tools = {
    description = "Serve it-tools static site";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.static-web-server}/bin/static-web-server --root ${pkgs.it-tools}/lib --port 8023";
      DynamicUser = true;
      Restart = "always";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8023 ];
}
