{ pkgs, ... }:
let
  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "ghostty";
    rev = "main";
    hash = "sha256-RlgTeBkjEvZpkZbhIss3KxQcvt0goy4WU+w9d2XCOnw=";
  };
in
{
  xdg.configFile."ghostty/config".text = ''
    font-family = "MonoLisa Variable"
    font-size = 19
    theme = "catppuccin-mocha.conf"
    window-vsync = false
    window-decoration = false
  '';

  xdg.configFile."ghostty/themes/catppuccin-mocha.conf".source =
    "${catppuccin-mocha}/themes/catppuccin-mocha.conf";
}
