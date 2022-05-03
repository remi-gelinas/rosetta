(module dotfiles.plugin.treesitter
        {autoload {ts :nvim-treesitter.configs
                   ts_to :nvim-treesitter-textobjects}})

(ts.setup {:ensure_installed :maintained
           :highlight {:enable true}
           :incremental_selection {:enable true}
           :indent {:enable true}
           :textobjects {:select {:enable true
                                  :keymaps {:af "@function.outer"
                                            :if "@function.inner"
                                            :ac "@conditional.outer"
                                            :ic "@conditional.inner"
                                            :aa "@parameter.outer"
                                            :ia "@parameter.inner"
                                            :av "@variable.outer"
                                            :iv "@variable.inner"}}}})
