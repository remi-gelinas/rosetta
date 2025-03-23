{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        settings = {
          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
            };

            statix = {
              enable = true;
              package = pkgs.statix;
            };

            nixfmt-rfc-style.enable = true;
            commitizen.enable = true;
            actionlint.enable = true;
          };
        };
      };
    };
}
