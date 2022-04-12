(module dotfiles.util {})

(defn safe-require [path]
      (let [(ok? val-or-err) (pcall require path)]
        (when (not ok?)
          (print (.. "Error requiring module: " val-or-err)))))

