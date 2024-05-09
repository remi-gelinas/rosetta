{ config, ... }:
{
  services.sketchybar = {
    enable = true;

    config = ''
      sketchybar --update
    '';
  };
}
