# Notes

Shell script for set of tasks to ease note taking and viewing.

## Requirements

* [ nvim ](https://neovim.io/) - I'm too lazy to setup variable for vim/nvim variation
* [ lsd ](https://github.com/Peltoche/lsd) - same as above - but `lsd` is really nice looking
* [ pandoc](https://pandoc.org/) - for generating htmls
* python3 - no need for python but lazy to implement browsing via custom htmls for clickable links for now

## Setup

Set `NOTES_DIRECTORY` variable at begining of script. This determines location where you want your notes to be saved (htmls will be saved here as well if you run `--generate`)

For example:

```sh
NOTES_DIRECTORY="${HOME}/notes/school"
```

`CSS_FILE` variable is used if css for pandoc is present, if variable is empty, pandoc wont use any

For example:

```sh
CSS_FILE=$(readlink -f "$0"/pandoc.css)
```

