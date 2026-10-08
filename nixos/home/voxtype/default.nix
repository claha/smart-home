{
  config,
  lib,
  pkgs,
  ...
}:
let
  # nixpkgs' voxtype-onnx ships the Quickshell OSD launcher but neither the
  # QML tree it loads nor `qs` on its PATH, so the OSD child always exits 3.
  # Upstream does ship the QML, so install it and wrap the launcher.
  voxtype = pkgs.unstable.voxtype-onnx.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      cp -r quickshell $out/share/voxtype/quickshell

      # The OSD shell spawns `voxtype-audio-bridge` by bare name, so this
      # wrapper has to supply both qs and our own bin.
      wrapProgram $out/bin/voxtype-osd-quickshell \
        --prefix PATH : ${lib.makeBinPath [ pkgs.quickshell ]}:$out/bin
    '';
  });
in
{
  services.voxtype = {
    enable = true;
    package = voxtype;

    wayland.display = "wayland-1";

    loadModels = [
      "parakeet-tdt-0.6b-v3-int8"
    ];

    settings = {
      state_file = "auto";
      engine = "parakeet";
      parakeet = {
        model = "parakeet-tdt-0.6b-v3-int8";
        model_type = "tdt";
      };
      hotkey = {
        enabled = false;
      };
      osd = {
        frontend = "quickshell";
      };
      status = {
        icon_theme = "nerd-font";
      };
      output = {
        notification = {
          on_transcription = false;
        };
      };
    };

    environment.VOXTYPE_OSD_QML_PATH = "${voxtype}/share/voxtype/quickshell";
  };
}
