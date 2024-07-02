rosetta:
let
  inherit (rosetta.config.rosetta) commonModules nixpkgsConfig;
in
{
  _file = ./rosetta-bridge.nix;

  imports = with commonModules; [
    user
    colours
  ];

  nixpkgs.config = nixpkgsConfig;
}
