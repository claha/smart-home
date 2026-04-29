{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "no";
        font = "JetBrains Mono:size 12";
        layer = "overlay";
        match-mode = "fuzzy";
        terminal = "${pkgs.wezterm}/bin/wezterm";
      };
      colors = {
        background = "000000b2";
        match = "ee5396ff";
        selection-match = "ee5396ff";
        selection = "262626ff";
        selection-text = "e66100ff";
        border = "e66100ff";
      };
    };
  };
}
