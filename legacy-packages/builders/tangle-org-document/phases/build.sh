emacs -Q --batch \
	--eval "(require 'org)" \
	--eval "(org-babel-tangle-file \"$buildDir/$documentName\")"
