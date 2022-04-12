{ config, lib, pkgs, ... }:
let
  brewBinPath = "/opt/homebrew/bin";
  yabai = "${brewBinPath}/yabai";

  focusedWindowBorderColor = "#${pkgs.lib.colors.nord.colors.nord11}";
in
{
  executable = true;
  text = ''
    sudo ${yabai} --load-sa
    ${yabai} -m signal --add event=dock_did_restart action="sudo ${yabai} --load-sa"

    ${yabai} -m config layout bsp
    ${yabai} -m config focus_follows_mouse autofocus
    ${yabai} -m config window_topmost on

    # TODO: Leave statically set until https://github.com/cmacrae/spacebar/issues/96 is solved
    #${yabai} -m config external_bar all:0:$(${pkgs.spacebar}/bin/spacebar -m config height)
    ${yabai} -m config external_bar all:26:0

    ${yabai} -m config top_padding 20
    ${yabai} -m config bottom_padding 20
    ${yabai} -m config left_padding 20
    ${yabai} -m config right_padding 20
    ${yabai} -m config window_gap 20

    ${yabai} -m config window_border on
    ${yabai} -m config active_window_border_color ${focusedWindowBorderColor}

    ${yabai} -m config window_opacity on
    ${yabai} -m config active_window_opacity 1.0
    ${yabai} -m config normal_window_opacity 0.9
  '';
}
