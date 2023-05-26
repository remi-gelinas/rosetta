{withSystem}: {pkgs, ...}: {
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      (withSystem pkgs.system ({config, ...}: config.packages.gh-poi))
    ];
  };
}
