# Role to manage system administration tools

This role configures custom scripts, local or from url.

Local means script is from ansible repository files, url means downloading script from specified url. Link

## Role variables

* `custom_files`

List of scripts to install. For example, check the role variable `defaults`.

Notes:

- If `local` is defined for list item, it will try to find it from ansible repository files and template it.
- If `url` is defined for list item, it will try to download it from the URL.
- If `link` is defined for list item, it will try to make an alternative for the script.
- If `lineinfile` is defined, a line will be added/changed in file, supports regex.
- If `blockinfile` is defined, a block with multiple lines will be added/changed in file, regex not supported.

* `custom_directories`

List of custom directories to make. For example, check the role variable `defaults`.

* `custom_links`

List of custom links to make. For example, check the role variable `defaults`.
