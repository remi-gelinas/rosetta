(module dotfiles.plugin.lsp {autoload {lsp :lspconfig}})

; Typescript
(lsp.tsserver.setup {:on_attach (fn [client]
                                  (set client.resolved_capabilities.document_formatting
                                       false)
                                  (set client.resolved_capabilities.document_range_formatting
                                       false))})

; Rust
(lsp.rust_analyzer.setup {})

; Nix
(lsp.rnix.setup {})

