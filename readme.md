# QMK Documentation

This is a repo for playing around with mkdocs for QMK.

# Setup/Installation

    python3 -m pip install -r requirements.txt

# Serve locally

    cd docs/en
    mkdocs serve

# Translations

The support for i18n/l10n in mkdocs is... not good. Everything is limited to 2 letter ISO language codes, so that is what I have conformed to for now. I have looked at different solutions to the problem but none of them scale to QMK's size particularly well. The best solution is [mkdocs-static-i18n](https://github.com/ultrabug/mkdocs-static-i18n) but I ran into some difficulties:

* Building the site (which happens with every page change) went from 8 seconds to 120+ seconds
* The site itself (themes, etc) is still in English
* Switching between languages always takes you back to the homepage
* Localizing the Navigation menu will result in a huge `mkdocs.yml`
* Search is [global across languages](https://github.com/ultrabug/mkdocs-static-i18n#compatibility-with-the-search-plugin)- users will have to pick the search result for the correct language
* The naming convention (`<page_name>.<lang>.md`) puts everything into one big directory. This makes it hard to see which pages a particular language does and does not have translations for.

This has led me to build a solution where each language gets its own mkdocs "site". 

* Main english language pages at `docs/en/docs` with config at `docs/en/mkdocs.yml`
* Each translation gets its own subdirectory at `docs/<lang>` with a `docs/<lang>/mkdocs.yml` and a `docs/<lang>/docs` of its own.
* A script, `symlink_translation.sh`, has been provided for creating symlinks for not-yet-translated files to their Engilsh counterparts, so that the site can be previewed in that language
* Translators can work on their localized site by doing this:
    * `./symlink_translation.sh <lang>`
        * This step is optional, if you skip it non-translated pages will be 404. In production they will return the English page.
    * `cd docs/<lang>`
    * `mkdocs serve`
    * Open `http://localhost:8000/devel/<lang>` in your web browser
    * Make changes to files and watch as your web browser automatically reloads the content.
* Make sure not to commit any symlinks!

If you work with translations please [give me feedback](https://github.com/qmk/qmk_mkdocs/issues/new/choose). If I do not hear anything I will assume this system works well enough and does not need any changes.

# Things to Know

## New tip/warning boxes

https://squidfunk.github.io/mkdocs-material/reference/admonitions/#inline-blocks
