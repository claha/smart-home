{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homelab.mealie;
in
{
  options.homelab.mealie = {
    enable = lib.mkEnableOption "Mealie recipes";
  };

  config = lib.mkIf cfg.enable {
    services.mealie = {
      enable = true;
      package = pkgs.unstable.mealie;
      settings = {
        NLTK_DATA = "/var/lib/nltk_data";
      };
    };

    networking.firewall.allowedTCPPorts = [ config.services.mealie.port ];
  };
}
