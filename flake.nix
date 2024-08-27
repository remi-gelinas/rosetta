{
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        flake-parts-lib,
        withSystem,
        config,
        options,
        lib,
        ...
      }:
      let
        importApply =
          module:
          flake-parts-lib.importApply module {
            local = {
              inherit
                withSystem
                config
                options
                inputs
                lib
                ;
            };
          };

        parts = import ./parts { inherit importApply lib; };
      in
      {
        debug = true;

        imports = builtins.attrValues parts;

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
      }
    );

  inputs = {
    neovim.url = "github:nix-community/neovim-nightly-overlay";
  };
}
