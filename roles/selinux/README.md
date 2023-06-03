# Role to manage SELinux

Adapted from [selinux](https://github.com/linux-system-roles/selinux).

This role configures SELinux.

## Role variables

* `selinux_config_selinux: enforcing`

SELinux state. Can be `enforcing`, `permissive` or `disabled`.

* `selinux_config_selinuxtype`

SELinux type. Can be `targeted`, `minimum` or `mls`.

* `selinux_booleans`

SELinux booleans to set.

* `selinux_fcontexts`

SELinux file contexts to set.

* `selinux_restore_dirs`

SELinux labels on filesystem tree to restore.

* `restorecon_path`

Path to the `restorecon` binary.