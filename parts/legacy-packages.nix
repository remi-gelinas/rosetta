localFlake: _: {
  perSystem =
    { system, config, ... }:
    let
      pkgs = localFlake.withSystem system ({ pkgs, ... }: pkgs);
      sources = localFlake.withSystem system ({ config, ... }: config.sources);
    in
    {
      config.legacyPackages =
        let
          legacyPkgs = import ../legacy-packages;
        in
        {
          gh-poi = pkgs.callPackage legacyPkgs.gh-poi { source = sources.gh-poi; };
          editors.emacs = config.emacs.finalPackage;
        };
    };
}
