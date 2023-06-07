localFlake: {
  perSystem = {
    pkgs,
    lib,
    system,
    config,
    ...
  }: let
    inherit (lib) mkOption types;

    cfg = config.emacs;
  in {
    options.emacs = {
      init = mkOption {
        type = types.str;
        readOnly = true;
      };

      extraInit = mkOption {
        type = types.str;
        default = "";
      };

      earlyInit = mkOption {
        type = types.str;
        readOnly = true;
      };

      extraEarlyInit = mkOption {
        type = types.str;
        default = "";
      };

      package = mkOption {
        type = types.package;
        readOnly = true;
      };

      binaries = mkOption {
        type = types.listOf types.package;
        default = [];
      };

      extraBinaries = mkOption {
        type = types.listOf types.package;
        default = [];
      };
    };

    config.emacs = let
      emacs-config-org = localFlake.withSystem system ({config, ...}:
        config.legacyPackages.builders.tangleOrgDocument {
          name = "emacs-config-org";
          src = ./config.org;

          templateVars = {
            VARIABLE_FONT = "SF Pro";
            FIXED_FONT = "PragmataPro Mono Liga";
          };
        });
    in {
      init = builtins.readFile "${emacs-config-org}/init.el" + cfg.extraInit;
      earlyInit = builtins.readFile "${emacs-config-org}/early-init.el" + cfg.extraEarlyInit;

      package = let
        directories = cfg.binaries ++ cfg.extraBinaries;

        appendExtraBinaryDirectories = lib.optionalString ((builtins.length directories) != 0) ''
          (setq exec-path (append exec-path '( ${
            lib.concatMapStringsSep " " (x: ''"${x}/bin"'') directories
          } )))
          (setenv "PATH" (concat (getenv "PATH") ":${
            lib.concatMapStringsSep ":" (x: "${x}/bin") directories
          }"))
        '';
      in
        pkgs.callPackage (import config.legacyPackages.editors.emacs {
          inherit (localFlake.inputs) emacs-unstable;
          config = cfg.init + appendExtraBinaryDirectories;
        }) {};

      # Packages that are available to the emacs package system-wide.
      binaries = with pkgs; [
        direnv
        python311
      ];
    };

    # TODO: Enable check when https://github.com/NixOS/nix/pull/7759 is included in a CI-installable Nix version
    # config.checks.emacs = cfg.package;
  };
}
