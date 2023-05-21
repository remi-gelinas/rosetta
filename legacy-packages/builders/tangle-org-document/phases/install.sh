rm $buildDir/$documentName

install -d $out
install $buildDir/* $out
