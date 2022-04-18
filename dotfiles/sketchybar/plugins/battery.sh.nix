{ config, lib, pkgs, ... }:

let
  brewBinPath = "/opt/homebrew/bin";
  sketchybar = "${brewBinPath}/sketchybar";

  colors = pkgs.lib.colors.nord.colors;

  inherit (pkgs.utils.bash) result shebang;
in
{
  executable = true;

  text = ''
    ${shebang}

    PERCENT_REGEX="([[:digit:]]*)%"

    DETAILS="$(pmset -g batt)"

    if [[ $DETAILS =~ $PERCENT_REGEX ]]; then
      percent="''${BASH_REMATCH[1]}"

      if [ $percent -ge 60 ]; then
        ${sketchybar} --set $NAME icon.color=0xFF${colors.nord14}
      elif [ $percent -ge 20 ]; then
        ${sketchybar} --set $NAME icon.color=0xFF${colors.nord13}
      else
        ${sketchybar} --set $NAME icon.color=0xFF${colors.nord11}
      fi
    fi
  '';
}
