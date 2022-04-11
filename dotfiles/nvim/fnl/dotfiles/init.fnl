(module dotfiles.init {autoload {nvim aniseed.nvim}})

; Options and stuff
(set nvim.o.termguicolors true)
(set nvim.g.mapleader ",")
(vim.cmd "colorscheme nord")

; Plugin dotfiles.
(pcall require :dotfiles.plugin.treesitter)
(pcall require :dotfiles.plugin.lsp)
(pcall require :dotfiles.plugin.which-key)
(pcall require :dotfiles.plugin.leap)
(pcall require :dotfiles.plugin.neo-tree)
(pcall require :dotfiles.plugin.feline)
(pcall require :dotfiles.plugin.toggleterm)
(pcall require :dotfiles.plugin.comment)
(pcall require :dotfiles.plugin.indent-blankline)

