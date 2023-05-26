localFlake: _: {
  perSystem = {
    system,
    config,
    ...
  }: {
    packages =
      localFlake.withSystem system
      ({
        pkgs,
        config,
        inputs',
        ...
      }:
        import ../packages {inherit pkgs config inputs';});
    checks = config.packages;
  };
}
