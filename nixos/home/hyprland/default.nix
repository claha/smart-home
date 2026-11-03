{
  config,
  lib,
  pkgs,
  ...
}:
let
  wallpaper = "${config.home.homeDirectory}/.local/share/brac.jpg";
  dictationChord = "SUPER + R";
  powerMenuScript = pkgs.writeShellScript "hypr-power-menu" ''
    printf 'Lock\nLogout\nReboot\nShutdown' | ${pkgs.fuzzel}/bin/fuzzel --dmenu --width 50 --minimal-lines | while read -r choice; do
      case "$choice" in
        Lock) hyprlock ;;
        Logout) hyprctl dispatch exit ;;
        Reboot) systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
      esac
    done
  '';
in
{
  imports = [
    ../waybar
    ../fuzzel
  ];

  services.mako = {
    enable = true;
    settings = {
      background-color = "#00000080";
      border-color = "#e66100ff";
      border-radius = 4;
      border-size = 2;
      default-timeout = 5000;
      font = "JetBrains Mono 12";
    };
  };

  home = {
    packages = with pkgs; [
      brightnessctl
      wl-clipboard
      cliphist
      bibata-cursors
      libnotify
    ];
    file.".local/share/brac.jpg".source = ./brac.jpg;
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };

  # Home Manager hyprland module: generate the Lua config from Nix settings.
  # systemd is disabled because we start via greetd directly.
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    systemd.enable = false;
    configType = "lua";
    settings = {
      terminal = {
        _var = "wezterm";
      };
      menu = {
        _var = "fuzzel";
      };
      browser = {
        _var = "brave";
      };

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1.0;
      };

      workspace_rule = [
        {
          workspace = "1";
          monitor = "eDP-1";
        }
        {
          workspace = "2";
          monitor = "eDP-1";
        }
        {
          workspace = "3";
          monitor = "eDP-1";
        }
        {
          workspace = "4";
          monitor = "eDP-1";
        }
        {
          workspace = "5";
          monitor = "eDP-1";
        }
        {
          workspace = "6";
          monitor = "DP-1";
        }
        {
          workspace = "7";
          monitor = "DP-1";
        }
        {
          workspace = "8";
          monitor = "DP-1";
        }
        {
          workspace = "9";
          monitor = "DP-1";
        }
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          col = {
            active_border = "rgb(e66100)";
            inactive_border = "rgba(e6610044)";
          };
          resize_on_border = false;
          allow_tearing = false;
          layout = "scrolling";
        };

        input = {
          kb_layout = "se";
          kb_options = "caps:none";
          follow_mouse = 0;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        scrolling = {
          fullscreen_on_one_column = true;
          column_width = 0.5;
          direction = "right";
        };

        decoration = {
          rounding = 4;
          rounding_power = 4;
        };

        binds = {
          hide_special_on_workspace_change = true;
        };

        cursor = {
          inactive_timeout = 1;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
      };

      window_rule = {
        name = "borderless-tiling";
        match = {
          workspace = "w[t1]";
        };
        border_size = 0;
      };

      bind = [
        # Basic window operations
        {
          _args = [
            "SUPER + F"
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
          ];
        }
        {
          _args = [
            "SUPER + T"
            (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
          ];
        }
        {
          _args = [
            "SUPER + Return"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wezterm\")")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + Q"
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            "SUPER + D"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"fuzzel\")")
          ];
        }
        {
          _args = [
            "SUPER + B"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brave\")")
          ];
        }
        {
          _args = [
            "SUPER + M"
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }

        # Focus movement
        {
          _args = [
            "SUPER + left"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
          ];
        }
        {
          _args = [
            "SUPER + right"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
          ];
        }
        {
          _args = [
            "SUPER + up"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "SUPER + down"
            (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
          ];
        }

        # Workspace navigation
        {
          _args = [
            "SUPER + Tab"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + Tab"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })")
          ];
        }
        {
          _args = [
            "SUPER + CTRL + Tab"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"previous\" })")
          ];
        }

        # Special workspace
        {
          _args = [
            "SUPER + S"
            (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special(\"scratchpad\")")
          ];
        }
        {
          _args = [
            "SUPER + ALT + S"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"special:scratchpad\" })")
          ];
        }

        # Lock and clipboard
        {
          _args = [
            "SUPER + L"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprlock\")")
          ];
        }
        {
          _args = [
            "SUPER + V"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"cliphist list | fuzzel --dmenu --width 100 | cliphist decode | wl-copy\")")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + P"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${powerMenuScript}\")")
          ];
        }

        # Workspace switching (1-9)
        {
          _args = [
            "SUPER + 1"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 1"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1 })")
          ];
        }
        {
          _args = [
            "SUPER + 2"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 2"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2 })")
          ];
        }
        {
          _args = [
            "SUPER + 3"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 3"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3 })")
          ];
        }
        {
          _args = [
            "SUPER + 4"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 4"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4 })")
          ];
        }
        {
          _args = [
            "SUPER + 5"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 5"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5 })")
          ];
        }
        {
          _args = [
            "SUPER + 6"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 6"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6 })")
          ];
        }
        {
          _args = [
            "SUPER + 7"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 7"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7 })")
          ];
        }
        {
          _args = [
            "SUPER + 8"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 8"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8 })")
          ];
        }
        {
          _args = [
            "SUPER + 9"
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + 9"
            (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9 })")
          ];
        }

        # Mouse binds
        {
          _args = [
            "SUPER + ALT_L"
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }

        # Dictation
        {
          _args = [
            dictationChord
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hex dictation start\")")
          ];
        }
        {
          _args = [
            dictationChord
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hex dictation stop\")")
            { release = true; }
          ];
        }

        # Media keys
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 1%+\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl -e4 -n2 set 1%-\")")
            {
              locked = true;
              repeating = true;
            }
          ];
        }

        # Resize binds using hyprctl
        {
          _args = [
            "SUPER + ALT + right"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprctl dispatch resizeactive 5 0\")")
            { repeating = true; }
          ];
        }
        {
          _args = [
            "SUPER + ALT + left"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprctl dispatch resizeactive -5 0\")")
            { repeating = true; }
          ];
        }
        {
          _args = [
            "SUPER + ALT + up"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprctl dispatch resizeactive 0 5\")")
            { repeating = true; }
          ];
        }
        {
          _args = [
            "SUPER + ALT + down"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprctl dispatch resizeactive 0 -5\")")
            { repeating = true; }
          ];
        }
      ];
    };

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("${pkgs.waybar}/bin/waybar &")
        hl.exec_cmd("${pkgs.hyprpaper}/bin/hyprpaper &")
        hl.exec_cmd("${pkgs.hypridle}/bin/hypridle &")
        hl.exec_cmd("${pkgs.mako}/bin/mako &")
        hl.exec_cmd("${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store &")
        hl.exec_cmd("${pkgs.hyprlock}/bin/hyprlock &")
      end)
    '';
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = wallpaper;
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };
      background = [
        {
          path = "${wallpaper}";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = {
        outer_color = "rgb(230, 97, 0)";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
