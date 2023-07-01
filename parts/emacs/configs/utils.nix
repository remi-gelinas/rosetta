{mkEmacsPackage, ...}:
mkEmacsPackage "rosetta-utils" {
  code =
    #emacs-lisp
    ''
      (defmacro rosetta/hook-if-daemon (name &rest BODY)
        "If run in a daemon context, define a one-shot hook containing BODY
      to run after the first frame is created. If run outside of a daemon context,
      evaluate BODY immediately."
        (let ((hook-name
              (intern (concat "rosetta/hook-if-daemon/hook/" name))))
          `(cond
            ((daemonp)
            (defun ,hook-name ()
              (progn
                ,@BODY
                (remove-hook 'server-after-make-frame-hook ',hook-name)))
            (add-hook 'server-after-make-frame-hook ',hook-name))
            (t
            ,@BODY))))
    '';
}
