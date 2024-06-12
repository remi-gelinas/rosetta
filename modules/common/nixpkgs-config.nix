{ lib, ... }:
with lib;
{
  options.rosetta.nixpkgsConfig = with types; mkOption { type = attrsOf unspecified; };
}
