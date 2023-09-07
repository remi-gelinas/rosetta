{withSystem, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells = import ../devshells {inherit withSystem;} {inherit config pkgs;};
    checks = config.devShells;
  };
}
