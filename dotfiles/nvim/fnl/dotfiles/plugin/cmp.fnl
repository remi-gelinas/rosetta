(module dotfiles.plugin.cmp {autoload {cmp :cmp lsnip :luasnip}})

(cmp.setup {:snippet {:expand (fn [args]
                                (lsnip.lsp_expand args.body))}})

