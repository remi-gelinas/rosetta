{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.nixpkgsConfig = mkOption {
    type = types.attrsOf types.unspecified;
  };
}
