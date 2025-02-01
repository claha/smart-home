{ config, pkgs, ... }:

{
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      intel-compute-runtime
      vpl-gpu-rt
      vaapiVdpau
    ];
  };
}
