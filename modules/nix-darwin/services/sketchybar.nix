_: {
  _file = ./sketchybar.nix;

  services.sketchybar = {
    enable = true;

    config = ''
      sketchybar --update
    '';
  };
}
