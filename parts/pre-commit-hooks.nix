_: _: {
  perSystem = _: {
    pre-commit = {
      settings.hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        commitizen.enable = true;
      };
    };
  };
}
