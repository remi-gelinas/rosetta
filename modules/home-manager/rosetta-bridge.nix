rosetta:
let
  inherit (rosetta.config.rosetta) nixpkgsConfig;
in
{
  _file = ./rosetta-bridge.nix;

  imports = [
    ../common/user.nix
    ../common/colours.nix
  ];

  nixpkgs.config = nixpkgsConfig;
}
