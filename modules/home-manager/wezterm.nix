{nixpkgs-master}: {
  pkgs,
  config,
  ...
}: {
  programs.wezterm = let
    pkgs-master = import nixpkgs-master {
      inherit (pkgs) system;
      config = config.nixpkgsConfig;
    };
  in {
    enable = true;

    # Pull from nixpkgs-master until https://github.com/NixOS/nixpkgs/pull/233136 is merged to unstable
    package = pkgs-master.wezterm;

    extraConfig =
      #lua
      ''
        local wezterm = require 'wezterm'
        local config = {}

        if wezterm.config_builder then
        config = wezterm.config_builder()
        end

        config.font = wezterm.font("PragmataPro Mono Liga")
        config.font_size = 16.0
        config.color_scheme = 'Nord (base16)'
        config.enable_tab_bar = false
        config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"

        return config
      '';
  };
}
