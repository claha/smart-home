{ config, pkgs, ... }:

let
  micScript = pkgs.writeShellScript "waybar-mic" ''
    mic_mute=$(${pkgs.pipewire}/bin/pw-dump | ${pkgs.jq}/bin/jq -r '[.[] | select(.info.props."media.class" == "Audio/Source") | .info.params.Props[0].mute] | if any then "muted" else "on" end')
    if [ "$mic_mute" = "muted" ]; then
      echo '{"text": "󰍭", "tooltip": "Microphone muted", "class": "muted"}'
    else
      echo '{"text": "󰍬", "tooltip": "Microphone on", "class": "on"}'
    fi
  '';
in
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
          "custom/microphone"
          "network"
          "battery"
          "tray"
        ];

        "custom/microphone" = {
          exec = micScript;
          interval = 2;
          return-type = "json";
        };

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
