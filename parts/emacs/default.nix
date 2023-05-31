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
    };

    config.emacs = let
      emacs-config-org = localFlake.withSystem system ({config, ...}:
        config.legacyPackages.builders.tangleOrgDocument {
          src = ./config.org;
        });
    in {
      init = builtins.readFile "${emacs-config-org}/init.el" + cfg.extraInit;
      earlyInit = builtins.readFile "${emacs-config-org}/early-init.el" + cfg.extraEarlyInit;

      package = pkgs.callPackage (import config.legacyPackages.editors.emacs {
        inherit (localFlake.inputs) emacs-unstable;
        inherit (localFlake) withSystem;
        config = cfg.init;
      }) {};
    };

    # TODO: Enable check when https://github.com/NixOS/nix/pull/7759 is included in a CI-installable Nix version
    # config.checks.emacs = cfg.package;
  };
}
