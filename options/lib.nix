{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (flake-parts-lib) mkPerSystemOption mkSubmoduleOptions;
  inherit (lib) mkOption types;
in {
  options = {
    perSystem = mkPerSystemOption ({
      config,
      options,
      pkgs,
      ...
    }: {
      lib = mkSubmoduleOptions {
        mkDarwinSystem = mkOption {
          type = types.functionTo (types.lazyAttrsOf types.raw);
          default = abort "???";
        };
      };
    });
  };
}
