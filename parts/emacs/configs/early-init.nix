_: {
  perSystem = _: let
    name = "early-init";
  in {
    config.emacs.configPackages.${name} = {
      inherit name;

      code =
        #src: emacs-lisp
        ''
          (setq inhibit-splash-screen t)
        '';
    };
  };
}
