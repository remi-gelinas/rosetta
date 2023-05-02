{
  inputs,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.pragmata-pro = pkgs.callPackage ./package.nix {};
  };
}
