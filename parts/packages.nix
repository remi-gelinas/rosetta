{
  perSystem =
    { pkgs, ... }:
    {
      config.packages = import ../pkgs/top-level/all-packages.nix { inherit pkgs; };
    };
}
