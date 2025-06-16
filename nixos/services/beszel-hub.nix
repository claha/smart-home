{ config, ... }:

{
  imports =
    [
      ../modules/beszel-hub.nix
    ];

  services.beszel.hub = {
    enable = true;
    host = "0.0.0.0";
    environment = {
      SHARE_ALL_SYSTEMS = "true";
    };
  };
  networking.firewall.allowedTCPPorts = [ config.services.beszel.hub.port ];

}
