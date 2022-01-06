#!/usr/bin/env bash

# This script is used to build the complete site with translations. You do not need to use this normally.

set -e
#set -x

if [ -z "$1" ]; then
	echo "usage: $0 <branch>"
	exit 1
fi

# Prepare the site dir
rm -rf ../../site/??/$1/

# Set the site URL
pushd "$(dirname "${BASH_SOURCE[0]}")"/../docs
sed -i 's,/devel/,/'$1'/,' */mkdocs.yml
sed -i 's,/devel/,/'$1'/,' base.yml

# Build the translations
for translation in ??/; do

	echo '*** Building site for language' $translation
	pushd $translation
	mkdocs build
	cp ../versions.json ../site/$(basename "$PWD")
	popd

	echo "*** Moving ${translation}/site to site/${translation}/"
	mv $translation/site ../site/$translation/
	# echo "We are in ${command}"
	# cp versions.json ../sites/$command/
done
popd
