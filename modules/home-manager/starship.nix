_:
{ lib, ... }:
let
  # Functions for composing config

  # deadnix: skip
  conditional = text: "(${text})";

  withStyle = text: style: "[${text}](${style})";
  mkFormat = lib.concatStrings;
  mkDisabledModules =
    modules:
    builtins.listToAttrs (map (module: lib.attrsets.nameValuePair module { disabled = true; }) modules);

  # Prompt characters

  # deadnix: skip
  SPLITBAR = withStyle "╾─╼" "bold gray";

  # deadnix: skip
  VERTICAL_BAR = withStyle "│" "bold gray";

  CONNECTBAR = {
    UP = withStyle "└─╼" "bold gray";
    DOWN = withStyle "┌─╼" "bold gray";

    INVERTED = {
      UP = withStyle "╾─┘" "bold gray";
      DOWN = withStyle "╾─┐" "bold gray";
    };
  };

  MODULE = {
    OPEN = withStyle "❴" "bold gray";
    CLOSE = withStyle "❵" "bold gray";
  };
in
{
  _file = ./starship.nix;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings =
      {
        # Top level prompt format
        format = mkFormat [
          # Left
          "┠─╼"
          "$directory"

          # Right
          "$fill"
          "test :>"
        ];

        # Line 3 - right
        right_format = mkFormat [ (withStyle "${CONNECTBAR.INVERTED.UP} " "") ];

        # Modules
        fill.symbol = " ";

        directory = {
          format = mkFormat [
            MODULE.OPEN
            (withStyle "  $path " "bold cyan")
            MODULE.CLOSE
          ];

          truncation_length = 0;
        };

        nix_shell = {
          format = mkFormat [
            MODULE.OPEN
            (withStyle " $symbol $name " "bold cyan")
            MODULE.CLOSE
          ];
          symbol = "󱄅";
        };
      }
      //
      # Explicitly disable all unused modules
      mkDisabledModules [
        "aws"
        "azure"
        "battery"
        "buf"
        "bun"
        "c"
        "character"
        "cmake"
        "cmd_duration"
        "cobol"
        "conda"
        "container"
        "crystal"
        "daml"
        "dart"
        "deno"
        "docker_context"
        "dotnet"
        "elixir"
        "elm"
        "env_var"
        "erlang"
        "gcloud"
        "git_branch"
        "git_commit"
        "git_metrics"
        "git_state"
        "git_status"
        "golang"
        "haskell"
        "helm"
        "hg_branch"
        "hostname"
        "java"
        "jobs"
        "julia"
        "kotlin"
        "kubernetes"
        "localip"
        "lua"
        "memory_usage"
        "meson"
        "nim"
        "nodejs"
        "ocaml"
        "openstack"
        "package"
        "perl"
        "php"
        "pulumi"
        "purescript"
        "python"
        "raku"
        "red"
        "rlang"
        "ruby"
        "rust"
        "scala"
        "shell"
        "shlvl"
        "singularity"
        "spack"
        "status"
        "sudo"
        "swift"
        "terraform"
        "time"
        "username"
        "vagrant"
        "vcsh"
        "vlang"
        "zig"
        "line_break"
      ];
  };
}
