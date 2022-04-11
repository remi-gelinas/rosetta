(module dotfiles.plugin.lsp {autoload {lsp :lspconfig}})

; Typescript
(lsp.tsserver.setup {})

; Rust
(lsp.rust_analyzer.setup {})

; Nix
(lsp.rnix.setup {})

