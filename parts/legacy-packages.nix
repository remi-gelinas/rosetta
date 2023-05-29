localFlake: _: {
  perSystem = {system, ...}: let
    pkgs = localFlake.withSystem system ({pkgs, ...}: pkgs);
  in {
    config.legacyPackages = import ../legacy-packages pkgs;
  };
}
