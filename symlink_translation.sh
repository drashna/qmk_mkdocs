#!/usr/bin/env bash

# Setup the symlinks for working on a translation

set -e
set -x

if [ -z "$1" ]; then
	echo "usage: $0 <translation>"
	exit 1
fi

translation=$1
for file in $(find docs -name \*.md); do
	if ! [ -e ${translation}/${file} ]; then
		mkdir -p $(dirname ${translation}${file})
		# Ugly hack, but ChangeLog is the only subdir we have...
		if echo $file | grep -q ChangeLog; then
			ln -s ../../../${file} ${translation}${file}
		else
			ln -s ../../${file} ${translation}${file}
		fi
	fi
done
