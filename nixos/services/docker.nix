{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.docker;
in
{
  options.homelab.docker = {
    enable = lib.mkEnableOption "Docker daemon";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
    };
  };
}
