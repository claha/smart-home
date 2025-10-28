{
  config,
  pkgs,
  lib,
  ...
}:

{
  systemd.tmpfiles.rules = [
    "d /media/youtube 0775 jellyfin users - -"
  ];

  services.pinchflat = {
    enable = true;
    package = pkgs.unstable.pinchflat;
    openFirewall = true;
    mediaDir = "/media/youtube";
    selfhosted = true;
  };

  systemd.services.pinchflat = {
    serviceConfig = {
      User = "jellyfin";
      DynamicUser = lib.mkForce false;
    };
  };
}
