{self, ...}: {pkgs, osConfig, ...}: {
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      # self.packages.${osConfig.system}.gh-poi
    ];
  };
}
