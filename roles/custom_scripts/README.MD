# Role to manage system administration tools

This role configures custom scripts, local or from url.

Local means script is from ansible repository files, url means downloading script from specified url. Link

## Role variables

* `custom_scripts`

List of scripts to install. For example, check the role variable `defaults`.

Notes:

- If `local` is defined for list item, it will try to find it from ansible repository files and template it.
- If `url` is defined for list item, it will try to download it from the URL.
- If `link` is defined for list item, it will try to make an alternative for the script.
