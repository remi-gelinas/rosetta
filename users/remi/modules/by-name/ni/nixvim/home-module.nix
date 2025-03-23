{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    package = pkgs.master.neovim-unwrapped;
  };
}
