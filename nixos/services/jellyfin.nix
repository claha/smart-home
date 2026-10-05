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
    users.groups.media = { };

    systemd.tmpfiles.rules = [
      "d /media/movies 2775 root media - -"
      "d /media/shows 2775 root media - -"
      "d /media/anime 2775 root media - -"
      "d /media/youtube 2775 root media - -"
    ];

    users.users.manager.extraGroups = [ "media" ];
    users.users.jellyfin.extraGroups = [ "media" ];

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
        libva-vdpau-driver
      ];
    };
  };
}
