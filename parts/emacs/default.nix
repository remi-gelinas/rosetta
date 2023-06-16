localFlake: {
  imports = import ./configs localFlake;

  perSystem = {
    system,
    config,
    ...
  }: let
    localNixpkgs = import localFlake.inputs.nixpkgs-master {
      inherit system;
      config = localFlake.config.nixpkgsConfig;
      overlays = [localFlake.inputs.emacs-unstable.overlays.default];
    };

    inherit (import ./lib.nix localNixpkgs) generatePackageSource;

    inherit (localNixpkgs.lib) mkOption types;

    cfg = config.emacs;

    configPackageType = types.submodule ({config, ...}: {
      options = {
        name = mkOption {
          type = types.str;
        };

        tag = mkOption {
          type = types.str;
          default = "";
        };

        comment = mkOption {
          type = types.str;
          default = "";
        };

        code = mkOption {
          type = types.str;
        };

        requiresPackages = mkOption {
          type = types.functionTo (types.listOf types.package);
          default = _: [];
        };

        requiresBinariesFrom = mkOption {
          type = types.functionTo (types.listOf types.package);
          default = _: [];
        };

        finalBinaryPackages = mkOption {
          type = types.listOf types.package;
          readOnly = true;
        };

        finalPackage = mkOption {
          type = types.package;
          readOnly = true;
        };
      };

      config.finalBinaryPackages = config.requiresBinariesFrom localNixpkgs;

      config.finalPackage = let
        epkgs = localNixpkgs.emacsPackages;
      in
        epkgs.trivialBuild {
          pname = config.name;
          src = generatePackageSource {inherit (config) name tag comment code;};
          packageRequires = config.requiresPackages epkgs;
        };
    });
  in {
    options.emacs = {
      configPackages = mkOption {
        type = types.attrsOf configPackageType;
      };

      extraInit = mkOption {
        type = types.str;
        default = "";
      };

      extraConfigPackages = mkOption {
        type = types.attrsOf configPackageType;
        default = {};
      };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
      };
    };

    config.emacs = {
      finalPackage = with localNixpkgs; let
        inherit (lib.attrsets) mapAttrsToList;

        emacsPackage = callPackage (import config.legacyPackages.editors.emacs {
          inherit (localFlake.inputs) emacs-unstable;
        }) {};
      in
        (emacsPackagesFor emacsPackage).emacsWithPackages (
          _:
            []
            ++ (mapAttrsToList (_: pkg: pkg.finalPackage) config.emacs.configPackages)
            ++ (mapAttrsToList (_: pkg: pkg.finalPackage) config.emacs.extraConfigPackages)
        );
    };

    config.checks.emacs = cfg.package;
  };
}
