[![Build Status](https://github.com/rezizter/ansible_loki/actions/workflows/ci.yml/badge.svg)](https://github.com/rezizter/ansible_loki/actions/workflows/ci.yml)

# ansible-loki

An Ansible role to install Grafana Loki and Promtail.

# Credits
This is a fork from:

https://github.com/ashleykleynhans/ansible-loki

## Requirements

For the standard (from binary) install of loki/promtail:

- `unzip` on the hosts

## Role Variables

See `defaults/main.yml` to customize this role.

A basic configuration file is a follows:

```bash
vi inventories/host_vars/<YOUR SERVER/loki.yml
```
add:
```yaml
---
loki_version: 2.9.1
loki_install: true
```

## Dependencies

_None._

## Example Playbook

This role is driven by inventory groups:

```yaml
all:
  hosts:
    monitoring.host.example.org:
  children:
    loki:
      monitoring.host.example.org:
    promtail:
      monitoring.host.example.org:
```

And the playbook:

```yaml
- hosts: all
  roles:
    - role: rezizter.ansible_loki
```

## License

BSD-2-Clause

## Author Information

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
