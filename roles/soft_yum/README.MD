# Role to manage packages on CentOS/RedHat based hosts

This role configures CentOS/RedHat based OS host packages using apt. Supports:

* enabling/disabling epel repo
* packages to keep up to date
* packages to remove

## Role variables

* `soft_packages_keep_latest`

If set to *false*, packages will not automatically be upgraded.
Defaults to *true*

* `soft_epel_enabled`

If set to *false*, epel repo will not be enabled.
Defaults to *true*

* `soft_packages_latest`

List of packages to keep up to date. Example:

```yaml
soft_packages_latest:
  - vim
```

* `soft_packages_absent`

List of packages to remove. Example:

```yaml
soft_packages_absent:
  - vim
```

* `soft_extra_repos`

List of extra repos to install. Example:

```yaml
soft_extra_repos:
  - name: 'ceph'
    file: 'ceph'
    description: 'Ceph Quincy EL$releasever'
    baseurl: 'https://download.ceph.com/rpm-quincy/el$releasever/$basearch'
    gpgcheck: 'yes'
    gpgkey: 'https://download.ceph.com/keys/release.asc'
```