{
  config,
  pkgs,
  ...
}:
{
  services.voxtype = {
    enable = true;
    package = pkgs.unstable.voxtype;

    wayland.display = "wayland-1";

    loadModels = [
      "base.en"
    ];

    settings = {
      state_file = "auto";
      whisper = {
        model = "base.en";
        language = "en";
      };
      hotkey = {
        key = "F9";
      };
      status = {
        icon_theme = "nerd-font";
      };
    };
  };
}
