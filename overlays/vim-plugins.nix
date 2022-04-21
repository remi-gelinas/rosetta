self: super:
let
  buildPlugin = self.vimUtils.buildVimPluginFrom2Nix;
in
{
  vimPlugins = super.vimPlugins // {
    neo-tree-nvim = buildPlugin
      (
        let
          rev = "v2.8";
        in
        {
          pname = "neo-tree-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "nvim-neo-tree";
            repo = "neo-tree.nvim";
            sha256 = "sha256-HUVzfpnn4M0SMGPwkC9RGslUwnydsVMhJp7ttC8+igE=";

            inherit rev;
          };

          meta = {
            description = "A Neovim plugin to browse the file system and other tree like structures in whatever style suits you, including sidebars, floating windows, netrw split style, or all of them at once!";
            homepage = "https://github.com/nvim-neo-tree/neo-tree.nvim";
          };
        }
      );

    leap-nvim = buildPlugin
      (
        let
          rev = "e14aff7302fc825732a8a56c5299c356ff3a39cc";
        in
        {
          pname = "leap-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "ggandor";
            repo = "leap.nvim";
            sha256 = "sha256-hAZJ+9I+f622VFYC4ntuk1SssUK2Kr7/9OZVcrzM6eA=";

            inherit rev;
          };

          meta = {
            description = "Leap is a general-purpose motion plugin for Neovim.";
            homepage = "https://github.com/ggandor/leap.nvim";
          };
        }
      );

    nord-nvim = buildPlugin
      (
        let
          rev = "76ccce922250f1bd2c1506b8861ce87c2de15b44";
        in
        {
          pname = "nord-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "kunzaatko";
            repo = "nord.nvim";
            sha256 = "sha256-NkuNesR1veRCYI9UNOrbugo3vC//1y3iuFcpdZ5MlpQ=";

            inherit rev;
          };

          meta = {
            description = "A port of the popular and simplistic nord colour scheme to neovim.";
            homepage = "https://github.com/kunzaatko/nord.nvim";
          };
        }
      );

    alpha-nvim = buildPlugin
      (
        let
          rev = "665522838e5a5511ec888840b76bc7b9929ee115";
        in
        {
          pname = "alpha-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "goolord";
            repo = "alpha-nvim";
            sha256 = "sha256-/30QELLnb6wM9Iinp4Vykdx4wd1ZGHYdQoRR00vhCHA=";

            inherit rev;
          };

          meta = {
            description = "A fast and fully customizable greeter for neovim";
            homepage = "https://github.com/goolord/alpha.nvim";
          };
        }
      );

    dressing-nvim = buildPlugin
      (
        let
          rev = "cad08fac5ed6d5e8384d8c0759268e2f6b89b217";
        in
        {
          pname = "dressing-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "stevearc";
            repo = "dressing.nvim";
            sha256 = "sha256-/mYpGvL6zxgIdH/hDe8jksM1ZLj/wk/EeVpFgzcjgFE=";

            inherit rev;
          };

          meta = {
            homepage = "https://github.com/stevearc/dressing.nvim";
          };
        }
      );

    # Pin nvim-lspconfig to v0.2 until breaking changes land in trunk
    # https://www.reddit.com/r/neovim/comments/u5si2w/breaking_changes_inbound_next_few_weeks_for/
    # https://github.com/neovim/nvim-lspconfig/pull/1838
    nvim-lspconfig = super.vimPlugins.nvim-lspconfig.overrideAttrs (
      _:
      let
        # HEAD of 'feat/0_7_goodies'
        rev = "f8ea15196cc3dbf8e3582b09d08680b34d217680";
      in
      {
        version = rev;

        src = self.fetchFromGitHub {
          owner = "neovim";
          repo = "nvim-lspconfig";
          rev = rev;
          sha256 = "sha256-duuZNAvCKcDyPDydSn/M/6uM1YhDju7qUk9auBCGFYA=";
        };
      }
    );

    # Redefine null-ls, for some reason the existing nixpkgs plugin conflicts with nvim-lspconfig
    # Causes `Duplicate vim plugin: nvim-lspconfig`
    null-ls-nvim = buildPlugin
      (
        let
          rev = "a887bd6c1bb992ccf48e673b40e061c3e816204f";
        in
        {
          pname = "null-ls-nvim";

          version = rev;

          src = self.fetchFromGitHub {
            owner = "jose-elias-alvarez";
            repo = "null-ls.nvim";
            sha256 = "sha256-gbo5sMd+mT/U1nQYAci2pdYNEOg/qFrpVfv6gVawLtY=";

            inherit rev;
          };
        }
      );
  };
}
