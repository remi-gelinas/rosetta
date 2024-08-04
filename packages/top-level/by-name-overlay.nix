# https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/by-name-overlay.nix
baseDirectory: final: prev:
let
  utils = import ../../utils.nix { inherit (prev) lib; };

  inherit (builtins) readDir;
  inherit (prev.lib.attrsets) mapAttrs mapAttrsToList mergeAttrsList;
  inherit (utils) isShardedCorrectly;

  namesForShard =
    shard: type:
    if type != "directory" then
      { }
    else
      mapAttrs (
        name: _:
        assert isShardedCorrectly shard name;
        baseDirectory + "/${shard}/${name}/package.nix"
      ) (readDir (baseDirectory + "/${shard}"));

  packageFiles = mergeAttrsList (mapAttrsToList namesForShard (readDir baseDirectory));
in
{
  _internalCallByNamePackageFile = file: final.callPackage file { };
}
// mapAttrs (_: final._internalCallByNamePackageFile) packageFiles
