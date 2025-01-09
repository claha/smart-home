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
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };
}
