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
        rnix-lsp
      ];

      plugins = with pkgs.vimPlugins; [
        nvim-treesitter
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
      ];

      extraConfig = "let g:aniseed#env = v:true";
    };
  };

  xdg.configFile."nvim/fnl".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/fnl";
}
