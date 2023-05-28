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
      emacs-config-org = localFlake.withSystem (builtins.trace system system) (localFlakeArgs:
        localFlakeArgs.config.legacyPackages.tangleOrgDocument {
          src = ./config.org;
        });
    in {
      init = builtins.readFile "${emacs-config-org}/init.el" + cfg.extraInit;
      earlyInit = builtins.readFile "${emacs-config-org}/early-init.el" + cfg.extraEarlyInit;

      package = import ../../packages/emacs {
        inherit pkgs;
        inherit (localFlake.inputs) emacs-unstable;
        config = cfg.init;
      };
    };

    config.checks.emacs = cfg.package;
  };
}
