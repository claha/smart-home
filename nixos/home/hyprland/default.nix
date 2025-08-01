{ pkgs, ... }:

{
  imports = [
    ../waybar
    ../hyprpaper
    ../hypridle
    ../hyprlock
    ../fuzzel
  ];

  home.packages = with pkgs; [
    brightnessctl
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "wezterm";
      "$menu" = "fuzzel";
      exec-once = "waybar && hyprpaper && hypridle";
      monitor = ",preferred,auto,1.0";
      bind =
        [
          "$mod, F, fullscreen"
          "$mod, RETURN, exec, $terminal"
          "$mod SHIFT, Q, killactive"
          "$mod, D, exec, $menu"
          "$mod, M, exit"
          "$mod, P, pseudo"
          "$mod, J, togglesplit"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, L, exec, hyprlock"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList
            (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      bindel =
        [
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
}
