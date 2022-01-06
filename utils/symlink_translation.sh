#!/usr/bin/env bash

# Setup the symlinks for working on a translation

set -e
#set -x

if [ -z "$1" ]; then
	echo "usage: $0 <translation>"
	exit 1
fi

translation=$1

cd "$(dirname "${BASH_SOURCE[0]}")"/../docs/en

for file in $(find docs -type f); do
	if ! [ -e ../${file}/${translation} ]; then
		# Ugly hack, but ChangeLog is the only subdir we have...
		if echo $file | grep -q '/.*/'; then
			mkdir -p ../$(dirname ${file}/${translation})
			ln -s ../../../en/${translation} ../${file}/${translation}/
		else
			ln -s ../../en/${translation} ../${file}/${translation}/
		fi
	fi
done
