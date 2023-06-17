pkgs: {
  generatePackageSource = {
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
      ;;; ${name} --- ${tag}

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
}
