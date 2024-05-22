{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    email = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
  };
}
