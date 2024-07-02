{ lib, ... }:
with lib;
{
  options.users.users = mkOption {
    type = types.attrsOf (
      types.submodule (
        { config, ... }:
        {
          imports = [ ../common/user.nix ];

          # MacOS home directory locations won't change, so this is probably safe
          home = "/Users/${config.name}";
        }
      )
    );
  };
}
