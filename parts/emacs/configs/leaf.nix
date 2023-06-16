localFlake: {
  perSystem = _: {
    config.emacs.configPackages.leaf = {
      name = "leaf-config";
      tag = "Configure leaf.el.";
      comment = ''
        Configures leaf.el.
      '';
      code = ''
        ()
      '';
      requiresPackages = epkgs: [epkgs.leaf];
    };
  };
}
