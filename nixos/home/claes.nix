{ config, lib, pkgs, ... }:

let
  bar = lib.mkMerge [
    config.lib.stylix.sway.bar
    { position = "top"; }
  ];
in
{
  home.username = "claes";
  home.homeDirectory = "/home/claes";
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    dua
    duf
    silver-searcher
    libnotify
    wlr-randr
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      bell.duration = 0;
      colors.draw_bold_text_with_bright_colors = true;
      cursor = {
        blink_interval = 750;
        unfocused_hollow = true;
        style = {
          blinking = "On";
          shape = "Block";
        };
      };
      env.TERM = "alacritty";
      #      font.size = 16.0;
      #      font.normal = {
      #        family = "TerminessNerdFontMono";
      #      };
      hints.enabled = [
        {
          command = "xdg-open";
          post_processing = true;
          regex = "(ipfs:|ipns:|magnet:|mailto:|https:|http:|file:|git:|ssh:|ftp:)[^\\u0000-\\u001F\\u007F-\<>\"\\\\s{-}\\\\^⟨⟩`]+";
          binding = {
            key = "U";
            mods = "Control|Shift";
          };
          mouse = {
            enabled = true;
            mods = "None";
          };
        }
        {
          command = "Paste";
          post_processing = true;
          regex = "([[:alnum:]]|[[:punct:]])+(\\u002E)[[:alnum:]]+";
          binding = {
            key = "P";
            mods = "Control|Shift";
          };
          mouse = {
            enabled = true;
            mods = "None";
          };
        }
        {
          command = "Paste";
          post_processing = true;
          regex = "[0-9a-f]{5,40}";
          binding = {
            key = "S";
            mods = "Control|Shift";
          };
          mouse = {
            enabled = true;
            mods = "None";
          };
        }
      ];
      window.padding = {
        x = 2;
        y = 2;
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = {}
      config.enable_tab_bar = false
      return config
    '';
  };

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
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
    options = [ "--cmd" "cd" ];
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
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

  programs.git = {
    enable = true;
    userName = "Claes Hallström";
    userEmail = "hallstrom.claes@gmail.com";
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
    signing.key = "957A412F3C40DFCA";
    extraConfig = {
      github = {
        user = "claha";
      };
    };
  };

  programs.btop = {
    enable = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    extraConfig = {
      modes = "drun,run,ssh,window,combi";
      combi-modes = "run,drun";
      combi-hide-mode-prefix = true;
      display-combi = "run";
      # font = "TerminessNerdFontMono 18";
      fixed-num-lines = true;
      terminal = "${pkgs.wezterm}/bin/wezterm";
      disable-history = false;
      matching = "fuzzy";
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 4500;
    ignoreTimeout = true;
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        timeout = 295;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    package = pkgs.swayfx;
    config = rec {
      modifier = "Mod4";
      terminal = "${pkgs.wezterm}/bin/wezterm";
      seat = { "*" = { hide_cursor = "1000"; }; };
      input = {
        "*" = {
          xkb_layout = "se";
          xkb_options = "ctrl:nocaps";
        };
      };
      focus.followMouse = false;
      menu = "${pkgs.rofi}/bin/rofi -show combi";
      bars = [ bar ];
      gaps = {
        inner = 5;
        outer = 3;
        smartGaps = false;
        smartBorders = "on";
      };
      window = {
        titlebar = false;
        border = 2;
      };
    };
    extraConfig = ''
      corner_radius 6
    '';
  };

  programs.qutebrowser = {
    enable = true;
    settings = {
      colors = {
        webpage = {
          bg = "black";
          darkmode = {
            enabled = true;
            policy.images = "never";
          };
        };
      };
      #      fonts = {
      #        default_family = "TerminessNerdFontMono";
      #        default_size = "20px";
      #      };
      hints.uppercase = true;
      scrolling = {
        bar = "never";
        smooth = true;
      };
      tabs.show = "never";
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
      ytld = true;
      ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
      keep-open = true;
    };
  };

  programs.emacs = {
    enable = true;
  };

  programs.vim = {
    enable = true;
  };
}
