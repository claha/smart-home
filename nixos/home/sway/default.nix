{ config, lib, pkgs, ... }:
let
  bar = lib.mkMerge [
    config.lib.stylix.sway.bar
    {
      position = "top";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
    }
  ];
in
{
  home.packages = with pkgs; [
    alsa-utils
    libnotify
    wlr-randr
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars.default = {
      theme = "semi-native";
      icons = "material-nf";
      blocks = [
        {
          block = "cpu";
          format = " $icon  $utilization ";
        }
        {
          block = "memory";
          format = " $icon  $mem_total_used_percents ";
        }
        {
          block = "disk_space";
          path = "/";
          info_type = "available";
          alert_unit = "GB";
          format = " $icon  $available ";
        }
        {
          block = "battery";
          format = " $icon  $percentage ";
        }
        {
          block = "sound";
          driver = "alsa";
          show_volume_when_muted = true;
          format = " $icon  $volume ";
          click = [
            {
              button = "left";
              cmd = "wezterm -e alsamixer";
            }
          ];
        }
        {
          block = "time";
          interval = 5;
          format = " $icon  $timestamp.datetime(f:'%Y-%m-%d %R') ";
        }
      ];
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
}
