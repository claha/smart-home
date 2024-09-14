{ config, lib, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = {}
      config.enable_tab_bar = false
      return config
    '';
  };
}
