{
  pkgs,
  config,
  ...
}: {
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      config.packages.gh-poi
    ];
  };
}
