{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    dua
    duf
    fd
    silver-searcher
    figurine
  ];

  home.file.".hushlogin".text = "";

  programs.bash = {
    enable = true;
    initExtra = "${pkgs.figurine}/bin/figurine -f 3d.flf $(hostname)";
    historyControl = [ "ignoredups" ];
    shellAliases = {
      crush = "nix run github:numtide/llm-agents.nix#crush";
      opencode = "nix run github:numtide/llm-agents.nix#opencode";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = false;
    };
  };

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
    ];
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

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
      "--disable-ctrl-r"
    ];
  };

  programs.zellij = {
    enable = true;
    settings = {
      default_layout = "compact";
      pane_frames = false;
      on_force_close = "quit";
    };
  };

  programs.btop = {
    enable = true;
  };

  programs.vim = {
    enable = true;
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bat = {
    enable = true;
  };
}
