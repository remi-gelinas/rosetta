{lib, ...}: let
  # Functions for composing config
  conditional = text: "(${text})";
  withStyle = text: style: "[${text}](${style})";
  mkFormat = lib.concatStrings;
  mkDisabledModules = modules: builtins.listToAttrs (map (module: lib.attrsets.nameValuePair module {disabled = true;}) modules);

  # Prompt characters
  SPLITBAR = withStyle "╾─╼" "fg:gray";
  # GIT_SPLITBAR = withStyle "╰╼" "fg:gray";

  CONNECTBAR = {
    UP = withStyle "└─╼" "fg:gray";
    DOWN = withStyle "┌─╼" "fg:gray";

    INVERTED = {
      UP = withStyle "╾─┘" "fg:gray";
      DOWN = withStyle "╾─┐" "fg:gray";
    };
  };

  MODULE = {
    OPEN = withStyle "❴" "fg:gray";
    CLOSE = withStyle "❵" "fg:gray";
  };
in {
  programs.starship = {
    enable = true;

    settings =
      {
        # Top level prompt format
        format = mkFormat [
          "$line_break"

          # Line 1 - left
          CONNECTBAR.DOWN
          "$directory"

          # Line 1 - right
          "$fill"
          "$nix_shell"
          (withStyle "${CONNECTBAR.INVERTED.DOWN} " "")

          "$line_break"

          # Line 2 - left
          (withStyle "${CONNECTBAR.UP} " "")
        ];

        # Line 2 - right
        right_format = mkFormat [
          (withStyle "${CONNECTBAR.INVERTED.UP} " "")
        ];

        # Modules
        fill.symbol = " ";

        directory = {
          format = withStyle (mkFormat [
            MODULE.OPEN
            (withStyle " $path " "bold cyan")
            MODULE.CLOSE
          ]) "";

          truncation_length = 2;
          fish_style_pwd_dir_length = 1;
        };

        nix_shell.format = withStyle (conditional (mkFormat [
          SPLITBAR
          MODULE.OPEN
          (withStyle " $name " "bold cyan")
          MODULE.CLOSE
        ])) "";

        kubernetes = {
          disabled = false;
          format = withStyle (conditional (mkFormat [
            SPLITBAR
            MODULE.OPEN
            (withStyle " $context " "bold cyan")
            MODULE.CLOSE
          ])) "";
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
        "cobol"
        "cmd_duration"
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
        "fennel"
        "fossil_branch"
        "gcloud"
        "git_branch"
        "git_commit"
        "git_state"
        "git_metrics"
        "git_status"
        "golang"
        "guix_shell"
        "gradle"
        "haskell"
        "haxe"
        "helm"
        "hostname"
        "java"
        "jobs"
        "julia"
        "kotlin"
        "localip"
        "lua"
        "memory_usage"
        "meson"
        "hg_branch"
        "nim"
        "nodejs"
        "ocaml"
        "opa"
        "openstack"
        "os"
        "package"
        "perl"
        "php"
        "pijul_channel"
        "pulumi"
        "purescript"
        "python"
        "rlang"
        "raku"
        "red"
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
        "vlang"
        "vcsh"
        "zig"
      ];
  };
}
