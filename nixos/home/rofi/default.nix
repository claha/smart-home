{ config, lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    extraConfig = {
      modes = "drun,run,ssh,window,combi";
      combi-modes = "run,drun";
      combi-hide-mode-prefix = true;
      display-combi = "run";
      # font = "TerminessNerdFontMono 18";
      fixed-num-lines = true;
      terminal = "${pkgs.wezterm}/bin/wezterm";
      disable-history = false;
      matching = "fuzzy";
    };
  };
}
