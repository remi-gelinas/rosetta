{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;

  flatten = list: builtins.foldl' (acc: v: acc ++ v) [ ] list;

  # Shamelessly modified from https://github.com/nix-community/nix-github-actions/blob/master/default.nix
  githubPlatforms = {
    x86_64-darwin = "macos-13";
    aarch64-linux = "ubuntu-24.04-arm";
    x86_64-linux = "ubuntu-latest";
    aarch64-darwin = "macos-14";
  };

  mkGithubActionsMatrix =
    {
      checks,
      attrPrefix ? "githubActions.checks",
    }:
    let

      mkEntry = system: attr: {
        inherit system;

        name = attr;

        os =
          let
            os = githubPlatforms.${system};
          in
          if builtins.typeOf os == "list" then os else [ os ];

        attr = if attrPrefix != "" then "${attrPrefix}.${system}.\"${attr}\"" else "${system}.\"${attr}\"";
      };

      mkSystemEntries = system: pkgs: (builtins.attrNames pkgs) |> (builtins.map (mkEntry system));
    in
    {
      inherit checks;

      matrix.include = checks |> builtins.mapAttrs mkSystemEntries |> builtins.attrValues |> flatten;
    };
in
{
  options.flake.githubActions = mkOption { type = types.unspecified; };

  config.flake.githubActions = mkGithubActionsMatrix {
    inherit (config.flake) checks;
  };
}
