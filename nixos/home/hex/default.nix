{ hexPackage, ... }:

{
  programs.hex = {
    enable = true;
    package = hexPackage.overrideAttrs (_: {
      doCheck = false;
    });
    autostart = true;
    model = "parakeet_unified_en";
    installModel = false;
    systemdTarget = "default.target";
  };
}
