{withSystem}: {pkgs, ...}: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = withSystem pkgs.system ({inputs', ...}: inputs'.nixpkgs-master.legacyPackages.yabai);

    extraConfig = ''
      yabai -m config debug_output on

      yabai -m config layout bsp
      yabai -m config focus_follows_mouse autofocus
      yabai -m config window_topmost off
      yabai -m config external_bar all:$(${pkgs.spacebar} -m config height):15

      yabai -m config top_padding 20
      yabai -m config bottom_padding 20
      yabai -m config left_padding 20
      yabai -m config right_padding 20
      yabai -m config window_gap 20

      yabai -m config window_opacity on
      yabai -m config active_window_opacity 1.0
      yabai -m config normal_window_opacity 0.9
    '';
  };
}
