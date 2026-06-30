{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) readDir;
  skillsRoot = ./skills;

  skillDirs = lib.filterAttrs (name: type: type == "directory") (readDir skillsRoot);
  skillNames = builtins.attrNames skillDirs;

  entries = lib.concatMap (
    skill:
    let
      dir = skillsRoot + "/${skill}";
      files = readDir dir;
      fileNames = builtins.attrNames files;
    in
    map (file: {
      name = ".agents/skills/${skill}/${file}";
      value = {
        source = skillsRoot + "/${skill}/${file}";
      };
    }) fileNames
  ) skillNames;
in
{
  home.file = builtins.listToAttrs entries;
}
