if [[ ! (-f $src) ]]; then
	echo "error: source must be a single file"
	exit 1
fi

documentName=$(echo $src | perl -wne '/.*-(.*)/i and print $1')
buildDir="dist"

install -d $buildDir
cp $src "$buildDir/$documentName"
