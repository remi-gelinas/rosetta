_: {pkgs, ...}: {
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      # self.packages.${osConfig.system}.gh-poi
    ];
  };
}
