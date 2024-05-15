{ nixpkgs-wezterm, ... }:
{ pkgs, ... }:
{
  _file = ./wezterm.nix;

  programs.wezterm = {
    enable = true;

    package = nixpkgs-wezterm.legacyPackages.${pkgs.system}.wezterm;

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
