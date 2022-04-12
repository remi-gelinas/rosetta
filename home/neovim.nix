{ config, lib, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
in
{
  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;

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
      ];

      plugins = with pkgs.vimPlugins; [
        impatient-nvim
        nvim-treesitter
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
        cmp-nvim-lsp
        cmp_luasnip
        indent-blankline-nvim
        which-key-nvim
        null-ls-nvim
      ];

      extraConfig = ''
        lua require('impatient')
        let g:aniseed#env = { 'module': 'dotfiles.init', 'compile': v:true }
      '';
    };
  };
}
