{
  inputs,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  config = {
    systems = ["x86_64-darwin" "aarch64-darwin"];

    perSystem = {
      config,
      pkgs,
      system,
      ...
    }: {
      lib.mkDarwinSystem = {
        modules ? [],
        extraModules ? [],
        homeModules ? [],
        extraHomeModules ? [],
      }: {};
    };
  };
}
