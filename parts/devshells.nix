_: _: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells = import ../devshells {inherit config pkgs;};
  };
}
