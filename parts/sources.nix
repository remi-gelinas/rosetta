_: {
  perSystem =
    { config, pkgs, ... }:
    let
      inherit (pkgs.lib) mkOption types;
    in
    {
      options.sources = mkOption { type = types.attrsOf types.unspecified; };

      config.sources =
        let
          inherit (pkgs.lib) pipe attrsets strings;
          sources = import ../_sources/generated.nix {
            inherit (pkgs)
              dockerTools
              fetchgit
              fetchurl
              fetchFromGitHub
              ;
          };

          patchVersion =
            sources:
            attrsets.mapAttrs (_: src: src // { version = strings.removePrefix "v" src.version; }) sources;
        in
        pipe sources [ patchVersion ];
    };
}
