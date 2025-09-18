{ config, lib, pkgs, ... }:

let
  cfg = config.myServices.udev;
in
{
  options.myServices.udev = {
    enable = lib.mkEnableOption "udev";

    devices = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule ({
        options = {
          serial = lib.mkOption {
            type = lib.types.str;
            description = "Serial number of the USB device (from udevadm info).";
          };
          mountPoint = lib.mkOption {
            type = lib.types.path;
            description = "Where to mount the device.";
          };
          user = lib.mkOption {
            type = lib.types.str;
            description = "User that should own the mount.";
            default = "root";
          };
        };
      }));
      default = [ ];
      description = "List of USB devices to automount by serial.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = lib.concatStringsSep "\n" (
      map
        (dev: ''
          ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", \
          ENV{ID_FS_USAGE}=="filesystem", ENV{ID_SERIAL_SHORT}=="${dev.serial}", \
          RUN+="${pkgs.systemd}/bin/systemd-mount --owner ${dev.user} --no-block --automount=yes --collect $devnode ${dev.mountPoint}"
        '')
        cfg.devices
    );
  };
}
