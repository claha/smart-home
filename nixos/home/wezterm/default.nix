{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = {}
      config.font = wezterm.font("JetBrains Mono")
      config.font_size = 14.0
      config.warn_about_missing_glyphs = false

      config.background = {
        {
          source = {
            Color = "black",
          },
          width = "100%",
          height = "100%",
          opacity = 0.70,
        },
      }

      config.enable_tab_bar = false
      config.window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5,
      }

      config.default_prog = {
        "${pkgs.bash}/bin/bash",
      }

      config.window_close_confirmation = "NeverPrompt"

      return config
    '';
  };
}
