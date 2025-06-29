{ config, ... }:
let
  wallpaper = "${config.home.homeDirectory}/.local/share/brac.jpg";
in
{
  home.file.".local/share/brac.jpg".source = ./brac.jpg;
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
    };
  };
}
