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
  };
}
