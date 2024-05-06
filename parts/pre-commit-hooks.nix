_: _: {
  perSystem = _: {
    pre-commit = {
      check.enable = false;

      settings = {
        hooks = {
          deadnix = {
            enable = true;
            excludes = [ "^_sources/.*.nix$" ];
          };
          statix.enable = true;
          commitizen.enable = true;
        };
      };
    };
  };
}
