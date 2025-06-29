{ config, lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "top";
    yoffset = 60;
    terminal = "${pkgs.wezterm}/bin/wezterm";
    modes = [ "drun" "run" "ssh" "window" "combi" ];
    font = "TerminessNerdFontMono 18";

    extraConfig = {
      combi-modes = "run,drun";
      combi-hide-mode-prefix = true;
      display-combi = "run";
      fixed-num-lines = true;
      disable-history = false;
      matching = "fuzzy";
    };
  };
}
