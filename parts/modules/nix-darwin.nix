{
  lib,
  config,
  flake-parts-lib,
  moduleLocation,
  inputs,
  ...
}:
let
  inherit (inputs) self home-manager nix-homebrew;
  inherit (lib) types mkOption mapAttrs;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in
{
  options.flake = mkSubmoduleOptions {
    darwinModules = mkOption {
      type = types.lazyAttrsOf types.deferredModule;

      default = { };

      apply = mapAttrs (
        k: v: {
          _file = "${toString moduleLocation}#darwinModules.${k}";
          imports = [ v ];
        }
      );

      description = ''
        nix-darwin modules.

        You may use this for reusable pieces of configuration, service modules, etc.
      '';
    };
  };

  config.flake.darwinModules =
    let
      modules = (import ../../modules/top-level/all-modules.nix { inherit lib; }).darwin;
    in
    modules
    // {
      cfg = {
        home-manager.sharedModules = builtins.attrValues config.flake.homeManagerModules;
        system.configurationRevision = lib.mkDefault (self.shortRev or self.dirtyShortRev);
      };

      # Re-export modules from inputs to ensure downstream flakes can build the config
      home-manager-module = home-manager.darwinModules.home-manager;
      nix-homebrew-module = nix-homebrew.darwinModules.nix-homebrew;
    };
}
