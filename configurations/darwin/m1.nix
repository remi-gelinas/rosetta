{
  self,
  lib,
  inputs,
  ...
}: rec {
  config.remi-nix.darwinConfigurations.M1 = rec {
    system = "aarch64-darwin";

    homeModules = let
      nur-no-pkgs = import inputs.nur {
        nurpkgs = import inputs.nixpkgs-stable {inherit system;};
        pkgs = throw "nixpkgs eval";
      };
    in [
      nur-no-pkgs.repos.rycee.hmModules.emacs-init
      {
        programs.gh = {
          extensions = [
            self.packages.${system}.gh-poi
          ];
        };
      }
    ];
  };

  config.remi-nix.darwinConfigurations.M1-ci =
    config.remi-nix.darwinConfigurations.M1
    // {
      system = "x86_64-darwin";

      primaryUser = {
        username = "runner";
        fullName = "";
        email = "";
        nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
      };

      modules = [{homebrew.enable = lib.mkForce false;}];
    };
}
