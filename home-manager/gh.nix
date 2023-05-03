{
  pkgs,
  flakePackages,
  ...
}: {
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      flakePackages.gh-poi
    ];
  };
}
