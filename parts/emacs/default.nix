localFlake: let
  inherit (import ./lib.nix) generatePackageSourceWithNixpkgs mkEmacsPackage;
in {
  imports = import ./configs {
    inherit localFlake mkEmacsPackage;
  };

  perSystem = {
    system,
    config,
    pkgs,
    ...
  }: let
    generatePackageSource = generatePackageSourceWithNixpkgs pkgs;

    inherit (pkgs.lib) mkOption types;

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
          type =
            types.either
            (types.functionTo (types.listOf types.package))
            (types.listOf types.package);
          default = [];
        };

        requiresBinariesFrom = mkOption {
          type =
            types.either
            (types.functionTo (types.listOf types.package))
            (types.listOf types.package);
          default = [];
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

      config.finalBinaryPackages = let
        type = builtins.typeOf config.requiresBinariesFrom;
      in
        if type == "lambda"
        then config.requiresBinariesFrom pkgs
        # then type is list - maybe explicitly throw here? Should be handled by the option type check
        else config.requiresBinariesFrom;

      config.finalPackage = let
        inherit
          (import localFlake.inputs.nixpkgs-master {
            inherit system;

            config = localFlake.config.nixpkgsConfig;
            overlays = [
              (_: _: {
                # Use my custom emacs to compile all elisp to ensure it all matches
                emacs = cfg.emacsPackage;
              })
              localFlake.inputs.emacs-unstable.overlays.default
            ];
          })
          emacsPackages
          ;
      in
        emacsPackages.trivialBuild {
          pname = config.name;

          src = generatePackageSource {inherit (config) name tag comment code;};

          packageRequires = let
            type = builtins.typeOf config.requiresPackages;
          in
            if type == "lambda"
            then config.requiresPackages emacsPackages
            # then type is list - maybe explicitly throw here? Should be handled by the option type check
            else config.requiresPackages;
        };
    });
  in {
    options.emacs = {
      configPackages = mkOption {
        type = types.attrsOf configPackageType;
      };

      extraConfigPackages = mkOption {
        type = types.attrsOf configPackageType;
        default = {};
      };

      emacsPackage = mkOption {
        type = types.package;
        readOnly = true;
      };

      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
      };
    };

    config.emacs = {
      emacsPackage = pkgs.callPackage (import config.legacyPackages.editors.emacs {
        inherit (localFlake.inputs) emacs-unstable;
      }) {};

      finalPackage = with pkgs; let
        inherit (lib.attrsets) mapAttrsToList;
      in
        (emacsPackagesFor config.emacs.emacsPackage).emacsWithPackages (
          _:
            []
            ++ (mapAttrsToList (_: pkg: pkg.finalPackage) config.emacs.configPackages)
            ++ (mapAttrsToList (_: pkg: pkg.finalPackage) config.emacs.extraConfigPackages)
        );
    };

    config.checks.emacs = cfg.finalPackage;
  };
}
