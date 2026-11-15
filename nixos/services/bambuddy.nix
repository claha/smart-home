{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.bambuddy;
in
{
  imports = [
    ../modules/bambuddy.nix
  ];

  options.homelab.bambuddy = {
    enable = lib.mkEnableOption "BamBuddy print archive";
  };

  config = lib.mkIf cfg.enable {
    services.bambuddy = {
      enable = true;
      package = pkgs.unstable.bambuddy;
      openFirewall = true;
      dataDir = "/data/bambuddy";
    };
  };
}
