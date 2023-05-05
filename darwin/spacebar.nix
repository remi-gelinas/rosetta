{pkgs, ...}: {
  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
  };
}
