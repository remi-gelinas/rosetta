{ config, lib, pkgs, ... }:

let
  inherit (pkgs.utils.bash) result;

  cmds = pkgs.utils.sketchybar.cmds config;
  inherit (cmds) item;

  brewBinPath = "/opt/homebrew/bin";
  sketchybar = "${brewBinPath}/sketchybar";

  colors = pkgs.lib.colors.nord.colors;

  withSettings = settings: lib.attrsets.mapAttrsToList (name: value: "${name}=${value}");

  prefixSettings = prefix: settings: builtins.map (setting: "${prefix}${setting}") settings;

  settingsTest = settings: lib.attrsets.mapAttrsRecursive (path: value: "${builtins.concatStringsSep "." path}=${value}");
in
{
  executable = true;

  text = ''
    ${sketchybar} --bar                       color=0xFF${colors.nord0}                                 \
                                              height=26                                                 \
                                                                                                        \
                  --default                   drawing=on                                                \
                                              lazy=off                                                  \
                                              updates=when_shown                                        \
                                              icon.font="PragmataProMonoLiga NF:Regular:18.0"            \
                                              icon.color=0xffffffff                                     \
                                              label.color=0xff${colors.nord6}                           \
                                              label.highlight_color=0xff8CABC8                          \
                                                                                                        \
                  --add item                  label_template left                                       \
                  --set label_template        icon.drawing.off                                          \
                                              label.font="PragmataProMonoLiga NF:Regular:12.0"           \
                                              drawing=off                                               \

      ${item "battery.sh"}
      ${item "spaces.sh"}

      ${sketchybar} --update

      echo "sketchybar configuration loaded.."
  '';
}
