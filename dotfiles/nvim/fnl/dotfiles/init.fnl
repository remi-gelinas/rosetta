(module dotfiles.init {autoload {nvim aniseed.nvim util dotfiles.util}})

(defn use-plugin-config [name] (util.safe-require (.. :dotfiles.plugin. name)))

; Options and stuff
(set nvim.o.termguicolors true)
(set nvim.g.mapleader ",")
(set nvim.o.relativenumber true)
(vim.cmd "colorscheme nord")

; Plugin dotfiles.
(use-plugin-config :treesitter)
(use-plugin-config :lsp)
(use-plugin-config :which-key)
(use-plugin-config :leap)
(use-plugin-config :neo-tree)
(use-plugin-config :feline)
(use-plugin-config :toggleterm)
(use-plugin-config :comment)
(use-plugin-config :indent-blankline)
(use-plugin-config :null-ls)
(use-plugin-config :cmp)

