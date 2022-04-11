(module dotfiles.init {autoload {nvim aniseed.nvim}})

(defn use-plugin-config [name]
      (let [(ok? val-or-err) (pcall require (.. :dotfiles.plugin. name))]
        (when (not ok?)
          (print (.. "Dotfiles config error: " val-or-err)))))

; Options and stuff
(set nvim.o.termguicolors true)
(set nvim.g.mapleader ",")
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

