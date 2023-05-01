{
  perSystem = {final, ...}: {
    overlayAttrs = {
      custom.emacs = final.emacsGit.override {nativeComp = true;};
    };
  };
}
