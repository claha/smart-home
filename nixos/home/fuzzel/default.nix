{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Terminess Nerd Font Monot:size 12";
        terminal = "${pkgs.wezterm}/bin/wezterm";
        layer = "overlay";
        fuzzy = true;
      };
      colors = {
        background = "000000b2";
        text = "fffffff";
        match = "ee5396ff";
        selection-match = "ee5396ff";
        selection = "262626ff";
        selection-text = "e66100ff";
        border = "e66100ff";
      };
    };
  };
}
