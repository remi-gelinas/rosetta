_: _: {
  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        settings = {
          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
              excludes = [ "^_sources/.*.nix$" ];
            };

            statix = {
              enable = true;
              package = pkgs.statix;
            };

            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
              excludes = [ "^_sources/.*.nix$" ];
            };

            commitizen.enable = true;
          };
        };
      };
    };
}
