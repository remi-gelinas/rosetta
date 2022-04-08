{ config, lib, pkgs, ... }:
with lib;
let
  configRoot = ".config";

  getDir = dir: mapAttrs
    (file: type:
      if type == "directory" then getDir "${dir}/${file}" else type
    )
    (builtins.readDir dir);

  getFiles = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  withConfig = file: "${configRoot}/${file}";

  configFileToPair = file:
    let
      isNix = strings.hasSuffix ".nix" file;
    in
    attrsets.nameValuePair
      (if isNix then strings.removeSuffix ".nix" (withConfig file) else (withConfig file))
      (if isNix then
        (import ../dotfiles/${file} { inherit config; inherit lib; inherit pkgs; }) else ({ text = builtins.readFile ../dotfiles/${file}; }));

  compiledConfigs = (files: builtins.listToAttrs (builtins.map configFileToPair files)) (getFiles ../dotfiles);
in
{
  home.file = compiledConfigs;
}
