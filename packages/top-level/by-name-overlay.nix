# https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/by-name-overlay.nix
baseDirectory: final: prev:
let
  inherit (builtins) readDir;

  inherit (prev.lib.attrsets) mapAttrs mapAttrsToList mergeAttrsList;

  namesForShard =
    shard: type:
    if type != "directory" then
      { }
    else
      mapAttrs (name: _: baseDirectory + "/${shard}/${name}/package.nix") (
        readDir (baseDirectory + "/${shard}")
      );

  packageFiles = mergeAttrsList (mapAttrsToList namesForShard (readDir baseDirectory));
in
{
  _internalCallByNamePackageFile = file: final.callPackage file { };
}
// mapAttrs (_: final._internalCallByNamePackageFile) packageFiles
