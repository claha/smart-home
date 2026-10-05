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
    services.pinchflat = {
      enable = true;
      package = pkgs.unstable.pinchflat;
      openFirewall = true;
      mediaDir = "/media/youtube";
      selfhosted = true;
    };

    systemd.services.pinchflat = {
      serviceConfig = {
        User = lib.mkForce "jellyfin";
        DynamicUser = lib.mkForce false;
      };
    };
  };
}
