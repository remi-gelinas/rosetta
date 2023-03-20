self: super: {
  custom.emacs = self.emacsGit.override { nativeComp = true; };
}
