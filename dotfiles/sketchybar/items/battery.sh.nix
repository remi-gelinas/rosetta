{ config, lib, pkgs, ... }:

let
  cmds = pkgs.utils.sketchybar.cmds config;
  inherit (cmds) plugin;

  brewBinPath = "/opt/homebrew/bin";
  sketchybar = "${brewBinPath}/sketchybar";

  colors = pkgs.lib.colors.nord.colors;

  inherit (pkgs.utils.bash) result;
  inherit (pkgs.utils.sh) shebang;

  itemName = "battery";
in
{
  executable = true;

  text = ''
    ${shebang}

    ${sketchybar} --add         item            ${itemName} right                                           \
                  --set         ${itemName}     icon=""                                                    \
                                                icon.font="PragmataProMonoLiga NF:Regular:40.0"             \
                                                update_freq=20                                              \
                                                script=${plugin "battery.sh"}                               \
  '';
}
