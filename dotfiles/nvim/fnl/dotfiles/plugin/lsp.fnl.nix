{ config, lib, pkgs, ... }:

{
  text = ''
    (module dotfiles.plugin.lsp {autoload {lsp :lspconfig}})

    ; 

    ; Typescript
    (lsp.tsserver.setup {:on_attach (fn [client]
                                      (set client.server_capabilities.documentFormattingProvider
                                           false)
                                      (set client.server_capabilities.documentRangeFormattingProvider
                                           false))})

    ; Rust
    (lsp.rust_analyzer.setup {})

    ; Nix
    (lsp.rnix.setup {})

    ; Elixir
    (lsp.elixirls.setup {:cmd "${pkgs.elixir_ls}/language_server.sh"})

  '';
}
