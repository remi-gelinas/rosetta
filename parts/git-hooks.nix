{
  _file = ./git-hooks.nix;

  perSystem =
    { pkgs, ... }:
    {
      pre-commit = {
        settings = {
          hooks = {
            deadnix = {
              enable = true;
              package = pkgs.deadnix;
              excludes = [ "^./npins/default.nix$" ];
            };

            statix = {
              enable = true;
              package = pkgs.statix;
            };

            nixfmt = {
              enable = true;
              package = pkgs.nixfmt-rfc-style;
              excludes = [ "^./npins/default.nix$" ];
            };

            commitizen.enable = true;
          };
        };
      };
    };
}
