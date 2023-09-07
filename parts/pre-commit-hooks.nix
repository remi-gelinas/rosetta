_: _: {
  perSystem = _: {
    pre-commit = {
      check.enable = false;

      settings = {
        settings.deadnix.exclude = ["./_sources/generated.nix"];

        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          commitizen.enable = true;
        };
      };
    };
  };
}
