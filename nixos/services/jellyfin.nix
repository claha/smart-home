{ config, pkgs, ... }:

let
  secrets = import ../secrets.nix { inherit config pkgs; };
in
{
  services.jellyfin = {
    enable = true;
    package = pkgs.unstable.jellyfin;
    user = "jellyfin";
    group = "jellyfin";
    openFirewall = true;
  };

  services.nginx.virtualHosts."jellyfin.media.${secrets.domain}" = {
    useACMEHost = "${secrets.domain}";
    acmeRoot = null;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:8096"; proxyWebsockets = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };
}
