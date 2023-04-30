{
  self,
  inputs,
  lib,
  ...
}: {
  flake.overlays = {
    # Overlays to add different versions `nixpkgs` into package set
    pkgs-master = _: prev: {
      pkgs-master = import inputs.nixpkgs-master {
        inherit (prev.stdenv) system;
        inherit (self.nixpkgsDefaults) config;
      };
    };
    pkgs-stable = _: prev: {
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (prev.stdenv) system;
        inherit (self.nixpkgsDefaults) config;
      };
    };
    pkgs-unstable = _: prev: {
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit (prev.stdenv) system;
        inherit (self.nixpkgsDefaults) config;
      };
    };
    apple-silicon = _: prev:
      lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
        # Add access to x86 packages system is running Apple Silicon
        pkgs-x86 = import inputs.nixpkgs-stable {
          system = "x86_64-darwin";
          inherit (self.nixpkgsDefaults) config;
        };
      };
    nur-no-pkgs = _: prev: {
      nur-no-pkgs = import inputs.nur {
        nurpkgs = import inputs.nixpkgs-stable {inherit (prev.stdenv) system;};
      };
    };

    custom-emacs = import ./emacs.nix;
    utils = import ./utils.nix;
    fonts = import ./fonts.nix;
    ssh-keys = import ./ssh-keys.nix;
    colors = import ./colors.nix;
    pkgs = import ./packages.nix;
  };
}
