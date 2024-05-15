{
  _file = ./packages.nix;

  perSystem =
    { pkgs, ... }:
    {
      config.packages =
        let
          packages = import ../packages;
        in
        {
          gh-poi = pkgs.callPackage packages.gh-poi { };
        };
    };
}
