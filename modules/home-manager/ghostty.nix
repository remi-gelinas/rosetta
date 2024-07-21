{ config, lib, ... }:
with lib;
let
  cfg = config.programs.ghostty;
in
{
  imports = [ { programs.ghostty.enable = true; } ];

  options.programs.ghostty = {
    enable = mkEnableOption "ghostty";

    package = mkPackageOption pkgs "ghostty" { };
  };

  config = mkIf cfg.enable {
    xdg.configFile."ghostty/config" = {
      text = ''
        font-family = "PragmataPro Mono Liga"
        font-size = 19
        theme = "nord"
      '';
    };
  };
}
