{
  pkgs,
  config,
  inputs,
  ...
}: let
  yabai-5_0_4 =
    (import inputs.nixpkgs-remi {
      inherit (pkgs) system;
      config = config.remi-nix.nixpkgsConfig;
    })
    .yabai;
in {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = yabai-5_0_4;

    extraConfig = ''
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
