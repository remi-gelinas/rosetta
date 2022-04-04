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
      ];

      plugins = with pkgs.vimPlugins; [
        aniseed
        conjure
        lightspeed-nvim
        neo-tree-nvim
        plenary-nvim
        feline-nvim
        toggleterm-nvim
      ];

      extraConfig = "lua require('aniseed.env').init()";
    };
  };

  xdg.configFile."nvim/fnl".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/fnl";
}
