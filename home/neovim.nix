{ config, lib, pkgs, ... }:
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
        tangerine-nvim
        lightspeed-nvim
      ];
    };
  };
}
