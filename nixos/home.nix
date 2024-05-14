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

  home.file.".hushlogin".text = "";

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
    defaultOptions = [
      "--height 50%"
      "--border sharp"
      "--no-scrollbar"
      "--layout reverse"
      "--cycle"
    ];
  };
  programs.git = {
    enable = true;
    aliases = {
      br = "branch";
      cfg = "config";
      ci = "commit";
      co = "checkout";
      cp = "cherry-pick";
      df = "diff";
      dfh = "diff HEAD^";
      dfn = "diff --name-only";
      dfnh = "diff HEAD^ --name-only";
      dt = "difftool";
      lg = "log --graph --abbrev-commit --date=relative --pretty=format:'%C(auto)%h%d%C(reset) %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      pu = "push origin HEAD";
      puf = "push --force origin HEAD";
      puu = "push --set-upstream origin HEAD";
      sm = "submodule";
      st = "status";
    };
  };
}
