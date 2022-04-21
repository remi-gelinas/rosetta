{ config, lib, pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs; [
        tree-sitter
        nodePackages.typescript-language-server
        nodePackages.eslint_d
        nodePackages."@fsouza/prettierd"
        rnix-lsp
        gh
        ripgrep
        fd
        rust-analyzer
        fnlfmt
      ];

      plugins = with pkgs.vimPlugins; [
        impatient-nvim
        (nvim-treesitter.withPlugins (
          plugins: pkgs.tree-sitter.allGrammars
        ))
        nvim-treesitter-textobjects
        nvim-lspconfig
        aniseed
        conjure
        leap-nvim
        neo-tree-nvim
        plenary-nvim
        feline-nvim
        toggleterm-nvim
        nvim-web-devicons
        nui-nvim
        lush-nvim
        nord-nvim
        barbar-nvim
        telescope-nvim
        octo-nvim
        comment-nvim
        luasnip
        nvim-cmp
        cmp-nvim-lsp
        cmp_luasnip
        indent-blankline-nvim
        which-key-nvim
        null-ls-nvim
        nvim-notify
        glow-nvim
        alpha-nvim
        dressing-nvim
      ];

      extraConfig = ''
        lua require('impatient')
        let g:aniseed#env = { 'module': 'dotfiles.init', 'compile': v:true }
      '';
    };
  };
}
