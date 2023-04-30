{
  lib,
  pkgs,
  ...
}: let
  focusedWindowBorderColor = "#${pkgs.lib.colors.nord.colors.nord11}";
in {
  services.yabai = {
    enable = true;

    extraConfig = ''
      yabai -m config layout bsp
      yabai -m config focus_follows_mouse autofocus
      yabai -m config window_topmost off

      yabai -m config top_padding 20
      yabai -m config bottom_padding 20
      yabai -m config left_padding 20
      yabai -m config right_padding 20
      yabai -m config window_gap 20

      yabai -m config window_border on
      yabai -m config active_window_border_color ${focusedWindowBorderColor}

      yabai -m config window_opacity on
      yabai -m config active_window_opacity 1.0
      yabai -m config normal_window_opacity 0.9
    '';
  };
}
