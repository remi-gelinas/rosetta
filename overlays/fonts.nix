{
  perSystem = {pkgs, ...}: {
    overlayAttrs = {
      pragmata-pro = pkgs.callPackage ../pkgs/pragmata-pro {};
    };
  };
}
