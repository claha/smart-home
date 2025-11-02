{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homelab.pinchflat;
in
{
  options.homelab.pinchflat = {
    enable = lib.mkEnableOption "Pinchflat media manager";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
