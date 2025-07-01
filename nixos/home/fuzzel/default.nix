{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.wezterm}/bin/wezterm";
        layer = "overlay";
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
