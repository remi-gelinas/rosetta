self: super:
let
  buildPlugin = self.vimUtils.buildVimPluginFrom2Nix;
in
{
  vimPlugins = super.vimPlugins // {
    tangerine-nvim = buildPlugin
      (
        let
          rev = "9dbfdf32038e776838eb9e953a3154d969cfecc1";
        in
        {
          pname = "tangerine-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "udayvir-singh";
            repo = "tangerine.nvim";
            sha256 = "sha256-TQSph0TqkL2t7ctzoYlY1HoUk/Grw9OcJP8P5RyMowM=";

            inherit rev;
          };

          meta = {
            description = "Tangerine provides a painless way to add fennel to your config.";
            homepage = "https://github.com/udayvir-singh/tangerine.nvim";
          };
        }
      );

    lightspeed-nvim = buildPlugin
      (
        let
          rev = "ecb8bbca37ee1c9d153e0835af507905af05f2b5";
        in
        {
          pname = "lightspeed-nvim";
          version = rev;
          src = self.fetchFromGitHub {
            owner = "ggandor";
            repo = "lightspeed.nvim";
            sha256 = "sha256-XcULXRUcha35NYH1tmEJxuiUhMG/MR1xJTEMmGwQYo0=";

            inherit rev;
          };

          meta = {
            description = "Lightspeed is a cutting-edge motion plugin for Neovim, with a small interface and lots of innovative ideas, that allow for making on-screen movements with yet unprecedented ease and efficiency.";
            homepage = "https://github.com/ggandor/lightspeed.nvim";
          };
        }
      );
  };
}
