# Role to manage netplan

Adapted from [ansible-netplan](https://github.com/mrlesmithjr/ansible-netplan)

## Role variables

* `netplan_config_file`

Netplan configuration file to be rendered by this role. Defaults to
`/etc/netplan/ansible-config.yaml`.

* `netplan_renderer`

Configured devices get handled by `systemd-networkd` by default, unless explicitly marked as managed by a specific renderer (i.e. NetworkManager). Defaults to none.

* `netplan_renderer_packages`

Renderer packages to be installed. Defaults to none.

* `netplan_configuration`

Netplan configuration to be rendered by this role. Defaults to none.

* `netplan_packages`

Netplan packages to be installed on Debian based distros.

* `netplan_apply`

Enable/disable netplan apply.

* `netplan_remove_existing`

Remove existing netplan configuration files. Defaults to `false`.
