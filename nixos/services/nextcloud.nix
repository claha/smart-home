{ self, config, lib, pkgs, ... }:
{
  services = {

    nginx.virtualHosts."nextcloud.hallstrom.duckdns.org".listen = [
      {
        addr = "127.0.0.1";
        port = 8086;
      }
    ];

    nextcloud = {
      enable = true;
      hostName = "nextcloud.hallstrom.duckdns.org";
      package = pkgs.nextcloud30;
      database.createLocally = true;
      configureRedis = true;
      maxUploadSize = "16G";
      https = true;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit deck calendar notes tasks;
      };
      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
      settings = {
        overwriteprotocol = "https";
        trusted_proxies = [ "127.0.0.1" ];
      };
    };
  };
}
