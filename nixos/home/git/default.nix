{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Claes Hallström";
    userEmail = "hallstrom.claes@gmail.com";
    aliases = {
      br = "branch";
      cfg = "config";
      ci = "commit";
      cia = "commit --amend --no-edit";
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
    diff-highlight.enable = true;
    signing.key = "957A412F3C40DFCA";
    extraConfig = {
      github = {
        user = "claha";
      };
      fetch = {
        prune = true;
      };
      rebase = {
        autosquash = true;
      };
    };
  };
}
