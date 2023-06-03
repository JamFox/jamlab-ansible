# Role to manage sshd

Adapted from [ansible-sshd](https://github.com/willshersystems/ansible-sshd.git)

This role configures the OpenSSH daemon. It:

* Can be configured by dict or simple variables
* Supports Match sets
* Supports all `sshd_config` options. Templates are programmatically generated.
  (see [`meta/make_option_lists`](meta/make_option_lists))

**WARNING** Misconfiguration of this role can lock you out of your server!
Please test your configuration and its interaction with your users configuration
before using in production!

## Role variables

* `sshd_manage_service`

If set to *false*, the service/daemon won't be **managed** at all, i.e. will not
try to enable on boot or start or reload the service. Defaults to *true*

* `sshd_allow_reload`

If set to *false*, a reload of sshd wont happen on change. This can help with
troubleshooting. You'll need to manually reload sshd if you want to apply the
changed configuration. Defaults to the same value as `sshd_manage_service`.

* `sshd_install_service`

If set to *true*, the role will install service files for the ssh service.
Defaults to *false*.

The templates for the service files to be used are pointed to by the variables

  - `sshd_service_template_service` (__default__: `templates/sshd.service.j2`)
  - `sshd_service_template_at_service` (__default__: `templates/sshd@.service.j2`)
  - `sshd_service_template_socket` (__default__: `templates/sshd.socket.j2`)

Using these variables, you can use your own custom templates. With the above
default templates, the name of the installed ssh service will be provided by
the `sshd_service` variable.

* `sshd`

A dict containing configuration.  e.g.

```yaml
sshd:
  Compression: delayed
  ListenAddress:
    - 0.0.0.0
```

* `sshd_...`

Simple variables can be used rather than a dict. Simple values override dict
values. e.g.:

```yaml
sshd_Compression: off
```

In all cases, booleans are correctly rendered as yes and no in sshd
configuration. Lists can be used for multiline configuration items. e.g.

```yaml
sshd_ListenAddress:
  - 0.0.0.0
  - '::'
```

Renders as:

```
ListenAddress 0.0.0.0
ListenAddress ::
```

* `sshd_match`, `sshd_match_1` through `sshd_match_9`

A list of dicts or just a dict for a Match section. Note, that these variables
do not override match blocks as defined in the `sshd` dict. All of the sources
will be reflected in the resulting configuration file. The use of
`sshd_match_*` variant is deprecated and no longer recommended.

* `sshd_backup`

When set to *false*, the original `sshd_config` file is not backed up. Default
is *true*.

* `sshd_config_file`

The path where the openssh configuration produced by this role should be saved.
This is useful mostly when generating configuration snippets to Include from
drop-in directory (default in Fedora and RHEL9).

When this path points to a drop-in directory (like
`/etc/ssh/sshd_confg.d/00-custom.conf`), the main configuration file (defined
with the variable `sshd_main_config_file`) is checked to contain a proper
`Include` directive.

* `sshd_config_namespace`

By default (*null*), the role defines whole content of the configuration file
including system defaults. You can use this variable to invoke this role from
other roles or from multiple places in a single playbook as an alternative to
using a drop-in directory.

When this variable is set, the role places the configuration that you specify
to configuration snippets in a existing configuration file under the given
namespace. You need to select different namespaces when invoking the role
several times.

Note that limitations of the openssh configuration file still apply. For
example, only the first option specified in a configuration file is effective
for most of the variables.

Technically, the role places snippets in `Match all` blocks, unless they contain
other match blocks, to ensure they are applied regardless of the previous match
blocks in the existing configuration file. This allows configuring any
non-conflicting options from different roles invocations.

* `sshd_config_owner`, `sshd_config_group`, `sshd_config_mode`

Use these variables to set the ownership and permissions for the openssh config
file that this role produces.

* `sshd_packages`

Use this variable to override the default list of packages to install.

* `sshd_binary`

The path to the openssh executable

* `sshd_service`

The name of the openssh service. By default, this variable contains the name of
the ssh service that the target platform uses. But it can also be used to set
the name of the custom ssh service when the `sshd_install_service` variable is
used.

* `sshd_sftp_server`

Default path to the sftp server binary.


## Example playbook

**DANGER!** This example is to show the range of configuration this role
provides. Running it will likely break your SSH access to the server!

```yaml
---
- hosts: all
  vars:
    sshd:
      Compression: true
      ListenAddress:
        - "0.0.0.0"
        - "::"
      GSSAPIAuthentication: no
      Match:
        - Condition: "Group user"
          GSSAPIAuthentication: yes
    sshd_UsePrivilegeSeparation: no
    sshd_match:
        - Condition: "Group xusers"
          X11Forwarding: yes
```

Results in:

```
# Ansible managed: ...
Compression yes
GSSAPIAuthentication no
UsePrivilegeSeparation no
Match Group user
  GSSAPIAuthentication yes
Match Group xusers
  X11Forwarding yes
```

You can just add a configuration snippet with the `sshd_config_namespace`
option:
```
---
sshd_config_namespace: accept-env
sshd:
# there are some handy environment variables to accept
AcceptEnv:
    LANG
    LS_COLORS
    EDITOR
```
The following snippet will be added to the default configuration file
(if not yet present):
```
# BEGIN sshd system role managed block: namespace accept-env
Match all
  AcceptEnv LANG LS_COLORS EDITOR
# END sshd system role managed block: namespace accept-env
```