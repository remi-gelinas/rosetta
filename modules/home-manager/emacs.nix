{withSystem}: {
  pkgs,
  config,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "emacsclient -c";
    VISUAL = "emacsclient -c";
  };

  programs.emacs = {
    enable = true;
    package = withSystem pkgs.system ({config, ...}: config.emacs.finalPackage);
  };

  programs.fish.shellAliases = {
    emacs = pkgs.lib.mkIf pkgs.stdenv.isDarwin "\"${config.home.homeDirectory}/Applications/Home Manager Apps/Emacs.app/Contents/MacOS/Emacs\"";
  };
}
