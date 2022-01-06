#!/usr/bin/env bash

# This script is used to build the complete site with translations. You do not need to use this normally.

set -e
#set -x

if [ -z "$1" ]; then
	echo "usage: $0 <branch>"
	exit 1
fi


# Set the site URL
pushd "$(dirname "${BASH_SOURCE[0]}")"/../docs
sed -i 's,/devel/,/'$1'/,' */mkdocs.yml
sed -i 's,/devel/,/'$1'/,' base.yml

# Build the translations
for translation in ??/; do
	echo "*** Setting up index.html and versions.json"
	cp versions.json $translation/

	echo '*** Building site for language' $translation
	pushd $translation
	mkdocs build
	popd

	cp index.html $translation/site/
	echo "*** Moving ${translation}/site to site/${translation}/"
	mv $translation/site ../site/$translation/
done
popd

git clone --branch gh-pages https://github.com/drashna/qmk_mkdocs.git dist
cp -a site/. dist/