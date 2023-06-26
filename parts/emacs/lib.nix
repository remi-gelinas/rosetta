{
  generatePackageSourceWithNixpkgs = pkgs: {
    name,
    tag,
    comment,
    code,
    ...
  }: let
    comments = with pkgs.lib;
      pipe comment [
        (strings.splitString "\n")
        (builtins.map (line: optionalString (line == "") ";; ${line}"))
        (strings.concatStringsSep "\n")
      ];

    prelude = ''
      ;;; ${name} --- ${tag} -*- lexical-binding: t -*-

      ;;; Commentary:

      ${comments}

      ;;; Code:
    '';

    postlude = ''
      (provide '${name})
      ;;; ${name}.el ends here
    '';
  in
    pkgs.writeText "${name}.el" ''
      ${prelude}
      ${code}
      ${postlude}
    '';

  mkEmacsPackage = name: cfg: {
    perSystem = args: {
      config.emacs.configPackages.${name} = let
        config = let
          cfgType = builtins.typeOf cfg;
        in
          if cfgType == "lambda"
          then (cfg (args // {packageName = name;}))
          else if cfgType == "set"
          then cfg
          else throw "Unsupported type for emacs package config: \"${cfgType}\"";
      in
        {
          inherit name;
        }
        // config;
    };
  };
}
