{ lib }:
let
  utils = import ../../utils.nix { inherit lib; };

  inherit (builtins) readDir listToAttrs;
  inherit (utils) isShardedCorrectly;
  inherit (lib)
    pipe
    attrNames
    concatMap
    filter
    filterAttrs
    hasPrefix
    ;

  getShardedModulesInPath =
    base:
    let
      childPaths = filter: path: attrNames (filterAttrs filter (readDir path));
      childDirs = childPaths (_: type: type == "directory");
      childFiles = childPaths (_: type: type == "regular");

      modulesInShard =
        { base, shard }:
        let
          modules = childDirs "${base}/${shard}";
        in
        map (module: { inherit base module shard; }) modules;

      filesInModule =
        {
          base,
          module,
          shard,
        }:
        let
          moduleBase = "${base}/${shard}/${module}";
          files = childFiles moduleBase;
        in
        assert isShardedCorrectly shard module;
        map (file: {
          inherit
            base
            module
            shard
            file
            ;
        }) files;

      shards = map (shard: { inherit base shard; }) (childDirs base);
    in
    pipe shards [
      (concatMap modulesInShard)
      (concatMap filesInModule)
    ];

  getShardedModuleFiles = getShardedModulesInPath ../by-name;

  filterShardedModuleFiles =
    f:
    pipe getShardedModuleFiles [
      (filter f)
      (map (
        {
          base,
          module,
          shard,
          file,
        }:
        {
          name = module;
          value = "${base}/${shard}/${module}/${file}";
        }
      ))
      listToAttrs
    ];
in
{
  darwin = filterShardedModuleFiles ({ file, ... }: hasPrefix "darwin-" file);
  home = filterShardedModuleFiles ({ file, ... }: hasPrefix "home-" file);
}
