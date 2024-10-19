{ lib }:
let
  inherit (builtins) readDir listToAttrs;
  inherit (lib)
    pipe
    attrNames
    concatMap
    filter
    filterAttrs
    ;

  inherit (import ./sharding.nix { inherit lib; }) isValidShard;

  self = {
    # Aggregates all valid sharded modules under a base path
    getShardedModulesInPath =
      base:
      let
        childPaths = filter: path: attrNames (filterAttrs filter (readDir path));
        childDirs = childPaths (_: type: type == "directory");
        childFiles = childPaths (_: type: type == "regular");

        modulesInShard =
          { base, shard }:
          let
            modules = childDirs (base + "/${shard}");
          in
          map (module: { inherit base module shard; }) modules;

        filesInModule =
          {
            base,
            module,
            shard,
          }:
          let
            moduleBase = base + "/${shard}/${module}";
            files = childFiles moduleBase;
          in
          assert isValidShard shard module;
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

    # Applies a filter to all sharded module files
    # Meant to be used in a pipeline with the result of getShardedModulesInPath
    filterShardedModuleFiles =
      modules: f:
      pipe modules [
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
            value = base + "/${shard}/${module}/${file}";
          }
        ))
        listToAttrs
      ];

    # Convenience method to get dependency modules according to my standard
    # For home-manager, NixOS, and nix-darwin module trees
    getSystemModulesInPath =
      base:
      let
        inherit (lib) hasPrefix;
        moduleFiles = self.getShardedModulesInPath base;
      in
      {
        darwin = self.filterShardedModuleFiles moduleFiles ({ file, ... }: hasPrefix "darwin-" file);
        home = self.filterShardedModuleFiles moduleFiles ({ file, ... }: hasPrefix "home-" file);
        nixos = self.filterShardedModuleFiles moduleFiles ({ file, ... }: hasPrefix "nixos-" file);
      };
  };
in
self
