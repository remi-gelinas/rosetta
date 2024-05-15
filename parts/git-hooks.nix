{ inputs, ... }:
{
  _file = ./git-hooks.nix;

  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        settings = {
          excludes = [ "^npins/.*.nix$" ];

          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
            };

            statix = {
              enable = true;
              package = pkgs.statix;

              # FIXME: https://github.com/cachix/git-hooks.nix/issues/288
              settings.ignore = [ "npins*" ];
            };

            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
            };

            commitizen.enable = true;
          };
        };
      };
    };
}
