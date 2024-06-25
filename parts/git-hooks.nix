{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        settings = {
          excludes = [ "^_sources/.*.nix$" ];

          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
            };

            statix = {
              enable = true;
              package = pkgs.statix;

              # FIXME: https://github.com/cachix/git-hooks.nix/issues/288
              settings.ignore = [ "_sources*" ];
            };

            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };

            commitizen.enable = true;
            actionlint.enable = true;
          };
        };
      };
    };
}
