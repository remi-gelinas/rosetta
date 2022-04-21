(module dotfiles.plugin.alpha {autoload {a :alpha}})

(let [opts {}
      header {:type :text val []}]
  (tset opts :layout [])
  (table.insert opts.layout {})
  (a.setup opts))

