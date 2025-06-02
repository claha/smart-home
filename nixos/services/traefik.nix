{ config, ... }:
{
  environment.etc.traefik = {
    source = ./traefik;
    user = "traefik";
    group = "traefik";
  };
  services.traefik = {
    enable = true;
    staticConfigFile = "/etc/traefik/static.yaml";
    # environmentFiles = [ config.age.secrets.duckdns-token.path ];  # Bug? Can not be used with staticConfigFile
  };
  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets.duckdns-token.path;
  };
}
