{
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.minetest-server;
  port = 30000;
in
{
  options.homelab.minetest-server = {
    enable = lib.mkEnableOption "Minetest server (Luanti)";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "luanti-5.14.0"
    ];

    services.minetest-server = {
      enable = true;
      port = 30000;
      world = "/var/lib/minetest/.minetest/worlds/myworld";
      gameId = "mineclonia";
      config = {
        server_name = "Mintest server";
        server_description = "A minetest server";
        name = "Claes";
        enable_damage = true;
        creative_mode = false;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ port ];
      allowedUDPPorts = [ port ];
    };
  };
}
