localFlake: {
  users-primaryUser = localFlake.config.commonModules.primaryUser;
  nixpkgs = import ./nixpkgs.nix localFlake;

  inherit (localFlake.config.commonModules) colors;
}
