{ withSystem }:
{ pkgs, config, ... }:
let
  cfg = config.pre-commit;
in
pkgs.mkShell {
  name = "rosetta";

  nativeBuildInputs = with pkgs; [
    cfg.settings.package

    (withSystem pkgs.system ({ inputs', ... }: inputs'.nix.packages.nix))
    (withSystem pkgs.system ({ inputs', ... }: inputs'.nixd.packages.nixd))
    (withSystem pkgs.system ({ inputs', ... }: inputs'.nvfetcher.packages.default))
    (withSystem pkgs.system ({ inputs', ... }: inputs'.nixpkgs-master.legacyPackages.nixfmt-rfc-style))

    statix
    deadnix
  ];

  shellHook = ''
    ${cfg.installationScript}
  '';
}
