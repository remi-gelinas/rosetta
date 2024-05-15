{ lib, config, ... }:
let
  cfg = {
    allowUnfree = true;
  };
in
{
  _file = ./nixpkgs-config.nix;

  options.nixpkgsConfig =
    (import config.commonModules.nixpkgsConfig { inherit lib; }).options.nixpkgsConfig;
  config.nixpkgsConfig = cfg;
}
