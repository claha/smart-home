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

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      onevpl-intel-gpu
    ];
  };
}
