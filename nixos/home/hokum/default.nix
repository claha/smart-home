{
  hokumPackage,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ hokumPackage ];

  home.file.".config/hokum/config.kdl".source = ./config.kdl;
}
