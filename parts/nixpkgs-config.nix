{ lib, config, ... }:
let
  cfg = {
    allowUnfree = true;
  };
in
{
  options.nixpkgsConfig =
    (import config.commonModules.nixpkgsConfig { inherit lib; }).options.nixpkgsConfig;
  config.nixpkgsConfig = cfg;
}
