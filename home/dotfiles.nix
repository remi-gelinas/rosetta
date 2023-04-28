{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  configRoot = config.xdg.configHome;

  # Utility functions
  utils = {
    cleanLua = ''
      rm -rf ${configRoot}/nvim/lua
    '';
  };

  # Handle converting non-Nix expression dotfiles into home-manager compliant attribute sets
  # This is mostly to avoid duplicating `onChange` attributes in every Fennel file for now
  handleFile = file:
    {
      text = builtins.readFile ../dotfiles/${file};
    }
    // attrsets.optionalAttrs (strings.hasSuffix ".fnl" file) {
      onChange = utils.cleanLua;
    };

  # Dotfile import logic
  getDir = dir:
    mapAttrs
    (
      file: type:
        if type == "directory"
        then getDir "${dir}/${file}"
        else type
    )
    (builtins.readDir dir);

  getFiles = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  withConfig = file: "${configRoot}/${file}";

  configFileToPair = file: let
    isNix = strings.hasSuffix ".nix" file;
  in
    attrsets.nameValuePair
    (
      if isNix
      then strings.removeSuffix ".nix" (withConfig file)
      else (withConfig file)
    )
    (
      if isNix
      then
        (import ../dotfiles/${file} {
          inherit config;
          inherit lib;
          inherit pkgs;
          inherit utils;
        })
      else (handleFile file)
    );

  compiledConfigs = (files: builtins.listToAttrs (builtins.map configFileToPair files)) (getFiles ../dotfiles);
in {
  home.file = compiledConfigs;
}
