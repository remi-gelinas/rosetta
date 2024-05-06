{ nixpkgs-wezterm, ... }: { pkgs
                          , config
                          , ...
                          }: {
  programs.wezterm =
    let
      pkgs-wezterm = import nixpkgs-wezterm {
        inherit (pkgs) system;
        config = config.nixpkgsConfig;
      };
    in
    {
      enable = true;

      package = pkgs-wezterm.wezterm;

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
