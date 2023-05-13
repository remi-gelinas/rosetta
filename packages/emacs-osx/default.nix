{
  pkgs,
  lib,
  ...
}: let
  # Slightly modifying the builder from nix-community/emacs-overlay here: https://github.com/nix-community/emacs-overlay/blob/bea7c7ba1c24ff791f2506e8af6e4eb88a414af5/overlays/emacs.nix#L3-L119
  # Method shamelessly lifted from https://github.com/sagittaros/emacs-osx/blob/main/emacs-overlay.nix
  mkGitEmacs = namePrefix: jsonFile: patches: args: let
    repoMeta = pkgs.lib.importJSON jsonFile;
    fetcher =
      if repoMeta.type == "savannah"
      then pkgs.fetchFromSavannah
      else if repoMeta.type == "github"
      then pkgs.fetchFromGitHub
      else throw "Unknown repository type ${repoMeta.type}!";
  in
    builtins.foldl'
    (drv: fn: fn drv)
    pkgs.emacs
    ([
        (drv: drv.override ({srcRepo = true;} // builtins.removeAttrs args ["noTreeSitter" "treeSitterPlugins"]))

        (
          drv:
            drv.overrideAttrs (
              old: {
                name = "${namePrefix}-${repoMeta.version}";
                inherit (repoMeta) version;
                src = fetcher (builtins.removeAttrs repoMeta ["type" "version"]);

                inherit patches;

                # fixes segfaults that only occur on aarch64-linux (#264)
                configureFlags =
                  old.configureFlags
                  ++ pkgs.lib.optionals (pkgs.stdenv.isLinux && pkgs.stdenv.isAarch64)
                  ["--enable-check-lisp-object-type"];

                postPatch =
                  old.postPatch
                  + ''
                    substituteInPlace lisp/loadup.el \
                    --replace '(emacs-repository-get-version)' '"${repoMeta.rev}"' \
                    --replace '(emacs-repository-get-branch)' '"master"'
                  ''
                  +
                  # XXX: Maybe remove when emacsLsp updates to use Emacs
                  # 29.  We already have logic in upstream Nixpkgs to use
                  # a different patch for earlier major versions of Emacs,
                  # but the major version for emacsLsp follows the format
                  # of version YYYYMMDD, as opposed to version (say) 29.
                  # Removing this here would also require that we don't
                  # overwrite the patches attribute in the overlay to an
                  # empty list since we would then expect the Nixpkgs
                  # patch to be used. Not sure if it's better to rely on
                  # upstream Nixpkgs since it's cumbersome to wait for
                  # things to get merged into master.
                  (pkgs.lib.optionalString (old ? NATIVE_FULL_AOT)
                    (let
                      backendPath =
                        pkgs.lib.concatStringsSep " "
                        (builtins.map (x: ''\"-B${x}\"'') ([
                            # Paths necessary so the JIT compiler finds its libraries:
                            "${pkgs.lib.getLib pkgs.libgccjit}/lib"
                            "${pkgs.lib.getLib pkgs.libgccjit}/lib/gcc"
                            "${pkgs.lib.getLib pkgs.stdenv.cc.libc}/lib"
                          ]
                          ++ pkgs.lib.optionals (pkgs.stdenv.cc ? cc.libgcc) [
                            "${pkgs.lib.getLib pkgs.stdenv.cc.cc.libgcc}/lib"
                          ]
                          ++ [
                            # Executable paths necessary for compilation (ld, as):
                            "${pkgs.lib.getBin pkgs.stdenv.cc.cc}/bin"
                            "${pkgs.lib.getBin pkgs.stdenv.cc.bintools}/bin"
                            "${pkgs.lib.getBin pkgs.stdenv.cc.bintools.bintools}/bin"
                          ]));
                    in ''
                                              substituteInPlace lisp/emacs-lisp/comp.el --replace \
                                                  "(defcustom comp-libgccjit-reproducer nil" \
                                                  "(setq native-comp-driver-options '(${backendPath}))
                      (defcustom comp-libgccjit-reproducer nil"
                    ''));
                # https://github.com/NixOS/nixpkgs/issues/109997#issuecomment-867318377
                CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=110200 -g -O2";
              }
            )
        )

        # reconnect pkgs to the built emacs
        (
          drv: let
            result = drv.overrideAttrs (old: {
              passthru =
                old.passthru
                // {
                  pkgs = pkgs.emacsPackagesFor result;
                };
            });
          in
            result
        )
      ]
      ++ (pkgs.lib.optional (! (args ? "noTreeSitter")) (
        drv:
          drv.overrideAttrs (
            old: let
              libName = drv: pkgs.lib.removeSuffix "-grammar" drv.pname;
              libSuffix =
                if pkgs.stdenv.isDarwin
                then "dylib"
                else "so";
              lib = drv: ''lib${libName drv}.${libSuffix}'';
              linkCmd = drv:
                if pkgs.stdenv.isDarwin
                then ''                  cp ${drv}/parser .
                                       chmod +w ./parser
                                       install_name_tool -id $out/lib/${lib drv} ./parser
                                       cp ./parser $out/lib/${lib drv}
                                       ${pkgs.pkgs.darwin.sigtool}/bin/codesign -s - -f $out/lib/${lib drv}
                ''
                else ''ln -s ${drv}/parser $out/lib/${lib drv}'';
              plugins = args.treeSitterPlugins;
              tree-sitter-grammars =
                pkgs.runCommandCC "tree-sitter-grammars" {}
                (pkgs.lib.concatStringsSep "\n" (["mkdir -p $out/lib"] ++ (map linkCmd plugins)));
            in {
              buildInputs = old.buildInputs ++ [pkgs.pkgs.tree-sitter tree-sitter-grammars];
              buildFlags =
                pkgs.lib.optionalString pkgs.stdenv.isDarwin
                "LDFLAGS=-Wl,-rpath,${pkgs.lib.makeLibraryPath [tree-sitter-grammars]}";
              TREE_SITTER_LIBS = "-ltree-sitter";
              # Add to list of directories dlopen/dynlib_open searches for tree sitter languages *.so
              postFixup =
                old.postFixup
                + pkgs.lib.optionalString pkgs.stdenv.isLinux ''
                  ${pkgs.pkgs.patchelf}/bin/patchelf --add-rpath ${pkgs.lib.makeLibraryPath [tree-sitter-grammars]} $out/bin/emacs
                '';
            }
          )
      )));

  defaultTreeSitterPlugins = with pkgs.tree-sitter-grammars; [
    tree-sitter-bash
    tree-sitter-c
    tree-sitter-c-sharp
    tree-sitter-cmake
    tree-sitter-cpp
    tree-sitter-css
    tree-sitter-dockerfile
    tree-sitter-go
    tree-sitter-gomod
    tree-sitter-html
    tree-sitter-java
    tree-sitter-javascript
    tree-sitter-json
    tree-sitter-python
    tree-sitter-ruby
    tree-sitter-rust
    tree-sitter-toml
    tree-sitter-tsx
    tree-sitter-typescript
    tree-sitter-yaml
  ];
in
  mkGitEmacs "emacs-osx" ./source.json [
    ./patches/no-titlebar.patch
    ./patches/fix-window-role.patch
  ] {
    nativeComp = true;
    treeSitterPlugins = defaultTreeSitterPlugins;
  }
