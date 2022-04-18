{ config, lib, pkgs, ... }:

let
  cmds = pkgs.utils.sketchybar.cmds config;
  inherit (cmds) plugin;

  brewBinPath = "/opt/homebrew/bin";
  sketchybar = "${brewBinPath}/sketchybar";

  colors = pkgs.lib.colors.nord.colors;

  inherit (pkgs.utils.sh) shebang;
in
{
  executable = true;

  text = ''
    ${shebang}

    ${sketchybar} --add         space           space_template left                                         \
                  --set         space_template  label.drawing=off                                           \
                                                drawing=off                                                 \
                                                updates=on                                                  \
                                                associated_display=1                                        \
                                                icon.font="PragmataProMonoLiga NF:Regular:40.0"             \
                                                                                                            \
                  --clone       code            space_template                                              \
                  --set         code            associated_space=1                                          \
                                                icon=""                                                    \
                                                label="code"                                                \
                                                drawing=on                                                  \
                                                                                                            \
                  --add         bracket         spaces_1                                                    \
                                                code                                                        \
  '';
}
