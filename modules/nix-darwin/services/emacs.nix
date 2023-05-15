{self, ...}: {pkgs, ...}: {
  services.emacs = {
    enable = false;
    package = self.packages.${pkgs.system}.emacs-plus-git;
  };
}
