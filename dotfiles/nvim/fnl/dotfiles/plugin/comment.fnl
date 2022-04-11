(module config.plugin.comment {autoload {cmt :Comment lsnip :luasnip}})

(cmt.setup {})
(cmp.setup {:snippet {:expand (fn [args]
                                (lsnip.lsp_expand args.body))}})

