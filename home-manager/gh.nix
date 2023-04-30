{pkgs, ...}: {
  programs.gh = {
    enable = true;

    extensions = [
      pkgs.gh-dash
      # pkgs.gh-poi
    ];
  };
}
