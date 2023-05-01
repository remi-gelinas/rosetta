{
  self,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./fonts.nix
    ./colors.nix
    ./packages.nix
    ./ssh-keys.nix
    ./emacs.nix
  ];

  perSystem = {
    system,
    pkgs,
    final,
    ...
  }: let
    inherit (lib.attrsets) optionalAttrs;
  in {
    overlayAttrs =
      {
        pkgs-master = import inputs.nixpkgs-master {
          inherit system;
          inherit (self.nixpkgsDefaults) config;
        };
        pkgs-stable = import inputs.nixpkgs-stable {
          inherit system;
          inherit (self.nixpkgsDefaults) config;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          inherit (self.nixpkgsDefaults) config;
        };
        nur-no-pkgs = import inputs.nur {
          nurpkgs = import inputs.nixpkgs-stable {inherit system;};
        };
      }
      // (optionalAttrs (system == "aarch64-darwin") {
        pkgs-x86 = import inputs.nixpkgs-stable {
          system = "x86_64-darwin";
          inherit (self.nixpkgsDefaults) config;
        };
      });
  };
}
