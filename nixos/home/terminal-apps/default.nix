{
  config,
  lib,
  pkgs,
  llmAgents,
  ...
}:

let
  inherit (config.home) homeDirectory;
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";

  # Focus an existing window instead of starting a second copy of the app.
  # Window classes are the app ids we pass to wezterm's --class below.
  focusOrLaunch = pkgs.writeShellScript "terminal-app-focus-or-launch" ''
    app_id="$1"
    shift

    address=$(${hyprctl} clients -j \
      | ${lib.getExe pkgs.jq} -r --arg id "$app_id" '.[] | select(.class == $id) | .address' \
      | head -n 1)

    if [ -n "$address" ]; then
      ${hyprctl} dispatch focuswindow "address:$address" >/dev/null
    else
      exec "$@"
    fi
  '';

  # Desktop entries for terminal (TUI) applications.
  #
  # We launch wezterm ourselves instead of relying on `terminal = true`,
  # because launchers such as fuzzel do not reliably know which terminal to
  # use. The window is tagged with `--class <id>`, and the same `id` is set as
  # StartupWMClass, so Hyprland and waybar can associate the window with this
  # entry (icon, focus, etc.). Hyprland then tiles it like any other window.
  mkTerminalApp =
    id:
    {
      name,
      command,
      icon,
      comment ? name,
      genericName ? name,
      categories ? [ "Development" ],
    }:
    {
      inherit
        name
        genericName
        comment
        icon
        categories
        ;
      type = "Application";
      terminal = false;
      exec = "${focusOrLaunch} ${id} ${pkgs.wezterm}/bin/wezterm start --class ${id} --cwd ${homeDirectory} -- ${command}";
      settings.StartupWMClass = id;
    };

  apps = {
    herdr = {
      name = "herdr";
      comment = "Terminal workspace manager for AI coding agents";
      command = "${llmAgents.herdr}/bin/herdr";
      icon =
        (pkgs.fetchurl {
          url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/herdr.png";
          sha256 = "sha256-1NIv5dFvxQyH4QgPrTgguxPz+4vIT1aNqqYqnQ1C2a4=";
        }).outPath;
    };
  };
in
{
  xdg.desktopEntries = lib.mapAttrs mkTerminalApp apps;
}
