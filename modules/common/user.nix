{ lib, ... }:
with lib;
{
  # Common user information to add to `nix-darwin` and `home-manager` user options.
  options = with types; {
    username = mkOption { type = str; };
    fullName = mkOption { type = str; };
    email = mkOption { type = str; };
    sshKey = mkOption { type = str; };
  };
}
