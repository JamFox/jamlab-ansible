# Role to manage DNS resolution

This role configures hostname, `resolv.conf` and /etc/hosts files. Supports:

* setting hostname
* the default `resolv.conf` file
* dynamic list of hosts to add to `/etc/hosts`

## Role variables

* `manage_resolv`

Whether to manage `resolv.conf` or not. Default: false

* `manage_hosts`

Whether to manage `/etc/hosts` or not. Default: false

* `manage_hostname`

Whether to manage hostname or not. Default: false

* `nameservers`

List of nameservers to configure in `resolv.conf`. Default: [] (none)

* `searchdomain`

Searchdomain to configure. Default: none

* `hosts_entries`

List of hosts to add to `/etc/hosts`. Example:

```yaml
hosts_entries:
  - "10.10.1.1   hpc.local            hpc"
  - "10.10.101.1 base.hpc.taltech.ee     "
```

* `hostname`

Hostname to set. Defaults to `ansible_hostname` variable. Example:

```yaml
hostname: "{{ ansible_hostname }}.hpc.local"
```
