{ config, pkgs, ... }:

{
  home.username = "manager";
  home.homeDirectory = "/home/manager";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    emacs-nox
  ];

  programs.bash = {
    enable = true;
  };
  programs.exa = {
    enable = true;
    enableAliases = true;
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
