_: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages = import ../packages {inherit pkgs self';};
  };
}
