{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
      ytld = true;
      ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
      keep-open = true;
    };
  };
}
