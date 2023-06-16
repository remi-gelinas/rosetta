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

    inherit (localNixpkgs.lib) mkOption types;

    cfg = config.emacs;

    configPackageType = types.submodule ({config, ...}: {
      options = {
        name = mkOption {
          type = types.str;
        };

        tag = mkOption {
          type = types.str;
        };

        comment = mkOption {
          type = types.str;
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

        finalPackage = mkOption {
          type = types.package;
          readOnly = true;
        };
      };

      config.finalPackage = let
        epkgs = localNixpkgs.emacsPackages;
      in
        epkgs.trivialBuild {
          pname = config.name;
          src = localNixpkgs.writeText config.name config.code;
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

    config.emacs = let
      # extra-init = pkgs.writeText "extra-init.el" cfg.extraInit;
      # init-postlude = let
      #   directories = cfg.binaries ++ cfg.extraBinaries;
      # in
      #   pkgs.writeText "init-postlude.el" (lib.optionalString ((builtins.length directories) != 0) ''
      #     (dolist (dir '(${lib.concatMapStringsSep " " (dir: ''"${dir}/bin"'') directories}))
      #       (add-to-list 'exec-path dir))
      #     (setenv "PATH" (concat "${lib.strings.makeBinPath directories}:" (getenv "PATH")))
      #   '');
      # init = pkgs.concatText "init.el" [
      #   (emacs-config-org + "/init.el")
      #   extra-init
      #   init-postlude
      # ];
    in {
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
