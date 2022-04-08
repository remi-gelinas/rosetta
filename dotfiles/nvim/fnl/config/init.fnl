(module config.init {autoload {core aniseed.core
                               nvim aniseed.nvim
                               leap leap
                               neo_tree neo-tree
                               feline feline
                               toggleterm toggleterm
                               nvim_ts :nvim-treesitter.configs
                               lsp :lspconfig}})

; Options and stuff
(set nvim.o.termguicolors true)
(set vim.opt.laststatus 3)
(set nvim.g.maplocalleader ",")
(vim.cmd "colorscheme nord")

; Plugin setup
(leap.setup {})
(neo_tree.setup {})
(feline.setup {})
(toggleterm.setup {})
(nvim_ts.setup {:ensure_installed :maintained
                :sync_install false
                :highlight {:enable true}})

; Language servers
(lsp.tsserver.setup {})
(lsp.rust_analyzer.setup {})
(lsp.rnix.setup {})

