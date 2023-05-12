_: {
  perSystem = let
    flakePackages = import ../packages;
  in
    {pkgs, ...}: {
      packages = builtins.mapAttrs (_: value: (pkgs.callPackage value {})) flakePackages;
    };
}
