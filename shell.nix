{
  packages ? pkgs: [
    pkgs.alejandra
    pkgs.jq
  ],
}: let
  flake = builtins.getFlake "${toString ./.}";

  pkgs = import flake.inputs.nixpkgs-unstable {};
in
  pkgs.mkShell {
    NIX_PATH = "nixpkgs=${flake.inputs.nixpkgs-unstable}";
    packages = packages pkgs;
  }
