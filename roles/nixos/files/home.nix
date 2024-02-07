{ config, pkgs, ... }:

{
  home.username = "manager";
  home.homeDirectory = "/home/manager";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    emacs-nox
    flexget
    spotdl
    svtplay-dl
    yt-dlp
  ];

  programs.bash = {
    enable = true;
  };
  programs.starship = {
    enable = true;
  };
  programs.eza = {
    enable = true;
    enableAliases = true;
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
