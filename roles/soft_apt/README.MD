# Role to manage packages on debian based hosts

This role configures debian based OS host packages using apt. Supports:

* packages to keep up to date
* packages to remove
* extra apt keys
* extra apt repos

## Role variables

* `soft_packages_keep_latest`

If set to *false*, packages will not automatically be upgraded.
Defaults to *true*

* `soft_packages_latest`

List of packages to keep up to date. Example:

```yaml
soft_packages_latest:
  - vim
```

* `soft_packages_absent`

List of packages to remove. 

```yaml
soft_packages_absent:
  - vim
```

* `soft_extra_sources`

Dict of extra keys to add to apt. Can be both by keyserver *and* id *or* just an url. Example:

```yaml
soft_extra_sources:
  - { keyserver: keyserver.ubuntu.com, id: F60F4B3D7FA2AF80 }
  - { url: https://ubuntu.com/keys/example.key }
```

* `soft_extra_repos`

Dict of extra repos to add to apt. Example:

```yaml
soft_extra_repos:
  - repo: "deb http://ee.archive.ubuntu.com/ubuntu focal main restricted"
```
