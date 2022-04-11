self: super:
let
  packages = import ./composition.nix { pkgs = self; };
in
{
  nodePackages = super.nodePackages // packages;
}
