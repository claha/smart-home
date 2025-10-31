{ config, pkgs, ... }:
let
  wallpaper = "${config.home.homeDirectory}/.local/share/brac.jpg";
in
{
  imports = [
    ../waybar
    ../fuzzel
  ];

  home = {
    packages = with pkgs; [
      brightnessctl
      wl-clipboard
      cliphist
    ];
    file.".local/share/brac.jpg".source = ./brac.jpg;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "wezterm";
      "$menu" = "fuzzel";
      "$browser" = "firefox";
      exec-once = [
        "waybar"
        "hyprpaper"
        "hypridle"
        "wl-paste --watch cliphist store"
        "hyprlock"
      ];
      monitor = ",preferred,auto,1.0";
      workspace = [
        "1,monitor:eDP-1"
        "2,monitor:eDP-1"
        "3,monitor:eDP-1"
        "4,monitor:eDP-1"
        "5,monitor:eDP-1"
        "6,monitor:DP-1"
        "7,monitor:DP-1"
        "8,monitor:DP-1"
        "9,monitor:DP-1"
      ];
      bind = [
        "$mod, F, fullscreen"
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod, D, exec, $menu"
        "$mod, B, exec, $browser"
        "$mod, M, exit"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, L, exec, hyprlock"
        "$mod, V, exec, cliphist list | fuzzel --dmenu --width 100 | cliphist decode | wl-copy"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 1%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 1%-"
      ];
      input = {
        kb_layout = "se";
        follow_mouse = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(e66100)";
        "col.inactive_border" = "rgba(e6610044)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      decoration = {
        rounding = 4;
        rounding_power = 4;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      cursor = {
        inactive_timeout = 1;
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
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
