{ pkgs, ... }:
{
  services.mealie = {
    enable = true;
    package = pkgs.unstable.mealie;
  };

  networking.firewall.allowedTCPPorts = [ 9000 ];
}
