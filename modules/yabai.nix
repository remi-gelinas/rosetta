{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
in {
  xdg.configFile."yabai".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/yabai";
}
