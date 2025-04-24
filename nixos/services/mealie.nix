{ pkgs, ... }:
{
  services.mealie = {
    enable = true;
    package = pkgs.unstable.mealie;
    settings = {
      NLTK_DATA = "/var/lib/nltk_data";
    };
  };

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
