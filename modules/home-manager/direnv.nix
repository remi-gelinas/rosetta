_: {
  _file = ./direnv.nix;

  programs = {
    direnv = {
      enable = true;

      nix-direnv = {
        enable = true;
      };
    };
  };
}
