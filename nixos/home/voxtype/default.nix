{
  config,
  pkgs,
  ...
}:
{
  services.voxtype = {
    enable = true;
    package = pkgs.unstable.voxtype-onnx;

    wayland.display = "wayland-1";

    loadModels = [
      "parakeet-tdt-0.6b-v3-int8"
    ];

    settings = {
      state_file = "auto";
      engine = "parakeet";
      parakeet = {
        model = "parakeet-tdt-0.6b-v3-int8";
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
