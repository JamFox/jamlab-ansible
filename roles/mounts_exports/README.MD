# Role to manage mounts and exports

This role configures mounts and exports. Supports:

* list of mounts to add to `/etc/fstab`
* list of exports to add to `/etc/exports`

## Role variables

* `mounts`

List of mounts to add to `/etc/fstab`. Example:

```yaml
mounts:
  - device: "10.10.10.10:/mnt/example"
    mount_point: "/share/example"
    mode: "0777"
    type: "nfs"
    options: "defaults,noatime,_netdev"
    dump: "0"
    pass: "0"
```

* `exports`

List of exports to add to `/etc/exports`. Example:

```yaml
exports:
  - directory: "/usr/share/example"
    mode: "0777"
    destinations: "10.10.10.10/24(rw,no_root_squash) 10.10.255.0/24(rw,no_root_squash)"
```
