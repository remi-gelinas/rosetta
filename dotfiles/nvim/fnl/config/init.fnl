(module config.init {autoload {nvim aniseed.nvim}})

; Options and stuff
(set nvim.o.termguicolors true)
(set nvim.g.mapleader ",")
(vim.cmd "colorscheme nord")

; Plugin configs
(pcall require :config.plugin.treesitter)
(pcall require :config.plugin.lsp)
(pcall require :config.plugin.which-key)
(pcall require :config.plugin.leap)
(pcall require :config.plugin.neo-tree)
(pcall require :config.plugin.feline)
(pcall require :config.plugin.toggleterm)
(pcall require :config.plugin.comment)
(pcall require :config.plugin.indent-blankline)

