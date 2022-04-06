(module config.init {autoload {core aniseed.core
                               nvim aniseed.nvim
                               leap leap
                               neo_tree neo-tree
                               feline feline
                               toggleterm toggleterm}})

; Options and stuff
(set nvim.o.termguicolors true)
(set nvim.g.maplocalleader ",")
(vim.cmd "colorscheme nord")

; Plugin setup
(leap.setup {})
(neo_tree.setup {})
(feline.setup {})
(toggleterm.setup {})

