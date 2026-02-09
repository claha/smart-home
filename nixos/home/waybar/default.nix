{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = [
      {
        layer = "top";
        position = "top";
        output = [ "eDP-1" ];
        height = 36;
        margin-top = 8;
        margin-left = 10;
        margin-right = 10;
        spacing = 0;

        modules-left = [ "clock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "tray"
        ];

        "clock" = {
          format = "{:%H:%M %A, %d %b %Y}";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{id}";
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
        };

        "network" = {
          format-wifi = "󰖩";
          format-disconnected = "󰖪";
          tooltip-format = "{essid}";
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = [
            "󰁺"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰁹"
          ];
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };
      }
      {
        layer = "top";
        position = "top";
        output = [
          "DP-1"
        ];
        height = 36;
        margin-top = 8;
        margin-left = 10;
        margin-right = 10;
        spacing = 0;

        modules-left = [ ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ ];

        "hyprland/workspaces" = {
          format = "{id}";
          persistent-workspaces = {
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
          };
        };
      }
    ];
  };
}
