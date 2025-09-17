{ ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = [ "eDP-1" ];
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        reload_style_on_change = true;
        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        "hyprland/workspaces" = {
          persistent-workspaces = {
            "*" = [ 1 2 3 4 5 ];
          };
        };
        clock = {
          format = "{:%H:%M}";
        };
        pulseaudio = {
          format = " {volume}%";
          format-bluetooth = " {volume}%  {format_source}";
          format-bluetooth-muted = "󰸈 {voume}%  {format_source}";
          format-muted = "󰸈 {volume}%";
        };
        network = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "";
          tooltip-format-disconnected = "Error";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format-ethernet = "{ifname} 🖧 ";
        };
        battery = {
          interval = 30;
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰂄 ";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
        };
        tray = {
          icon-size = 14;
          spacing = 10;
        };
      };
      externalBar = {
        layer = "top";
        position = "top";
        output = [ "DP-1" ];
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        reload_style_on_change = true;
        modules-left = [ ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ ];
        "hyprland/workspaces" = {
          persistent-workspaces = {
            "*" = [ 6 7 8 9 ];
          };
        };
      };
    };
    style = ./style.css;
  };
}
