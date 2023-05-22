_: {
  perSystem = {pkgs, ...}: {
    legacyPackages = import ../legacy-packages pkgs;
  };
}
