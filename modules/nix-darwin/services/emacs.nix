{self, ...}: {pkgs, ...}: {
  services.emacs = {
    enable = true;
    package = self.packages.${pkgs.system}.emacs;
  };
}
