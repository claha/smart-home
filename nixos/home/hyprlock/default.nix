{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = {
        hide_input = true;
        hide_input_base_color = "rgb(230, 97, 0)";
      };
    };
  };
}
