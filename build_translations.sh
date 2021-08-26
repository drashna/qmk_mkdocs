#!/usr/bin/env bash

# This script is used to build the complete site with translations. You do not need to use this normally.

set -e
set -x

# Prepare the site dir
rm -rf site
mkdir site

# Build the translations
pushd "$(dirname "${BASH_SOURCE[0]}")"/docs
for translation in ??/; do
	echo '*** Setting up symlinks for language' $translation
	../symlink_translation.sh $translation

	echo '*** Building site for language' $translation
	pushd $translation
	mkdocs build
	popd

	echo "*** Moving $translation/site to site/$translation"
	mv $translation/site ../site/$translation
done
popd
