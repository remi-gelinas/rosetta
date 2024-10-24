{ lib }:
let
  inherit (lib) toLower substring;
in
{
  # Used for package and module by-name assertions
  isShardedCorrectly = shard: obj: shard == toLower (substring 0 2 obj);
}
