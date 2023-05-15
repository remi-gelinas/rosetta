{self, ...}: {pkgs, ...}: {
  programs.wezterm = {
    enable = true;

    package =
      if pkgs.stdenv.isDarwin
      # Build using binary until https://github.com/NixOS/nixpkgs/issues/231291 is fixed
      then self.packages.${pkgs.system}.wezterm-bin
      else pkgs.wezterm;

    extraConfig = ''
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
