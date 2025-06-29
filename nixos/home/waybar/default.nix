{ ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        reload_style_on_change = true;
        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "network" "battery" "tray" ];
        "hyprland/workspaces" = {
          persistent-workspaces = {
            "*" = [ 1 2 3 4 5 ];
          };
        };
        clock = {
          format = "{:%H:%M}";
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
    };
    style = ./style.css;
  };
}
