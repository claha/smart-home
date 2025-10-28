{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.jellyfin;
in
{
  options.homelab.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";
    hardwareAcceleration = lib.mkEnableOption "Jellyfin hardware acceleration";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      package = pkgs.unstable.jellyfin;
      user = "jellyfin";
      group = "jellyfin";
      openFirewall = true;
    };

    environment.systemPackages = [
      pkgs.unstable.jellyfin-ffmpeg
      pkgs.unstable.jellyfin-web
    ];

    hardware.graphics = lib.mkIf cfg.hardwareAcceleration {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        intel-compute-runtime
        vpl-gpu-rt
        vaapiVdpau
      ];
    };
  };
}
