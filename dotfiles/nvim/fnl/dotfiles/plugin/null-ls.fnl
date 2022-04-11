(module dotfiles.plugin.null-ls {autoload {null :null-ls}})

(let [builtins null.builtins]
  (null.setup {sources [builtins.code_actions.eslint_d
                        builtins.diagnostics.eslint_d
                        builtins.formatting.prettierd]}))

