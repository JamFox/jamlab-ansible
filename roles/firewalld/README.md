# Role to manage firewalld

Adapted from [ansible-role-firewalld](https://github.com/aisbergg/ansible-role-firewalld) and [ansible-firewalld](https://github.com/ptrunk/ansible-firewalld).

This role configures firewalld.

## Role variables

* `firewalld_packages`

List of packages to install.

* `firewalld_enabled`

Enable the Firewalld. Defaults to true.

* `firewalld_service_state`

Manage the state of the Firewalld service. Defaults to `started`. Choices: `reloaded`, `restarted`, `started`, `stopped`.

* `firewalld_service_restart_on_change`

Restart Firewalld service on configuration changes. Defaults to `true`.

* `firewalld_rules`

List of firewall rules. The parameters can be looked up [here](https://docs.ansible.com/ansible/latest/modules/firewalld_module.html).* Defaults to `[]`.

* `firewalld_ipsets`

Ipsets to render into xml files. Defaults to `[]`.

* `firewalld_services`

Services to render into xml files. Defaults to `[]`.

* `firewalld_zones`

Zones to render into xml files. Defaults to `[]`.

* `firewalld_remove_unmanaged`

Whether or not to remove unmanaged xml ipsets, services and zones. Defaults to `true`.

* `firewalld_config`

A dict (key-value pairs) of Firewalld base configuration options. Defaults to `{}`.

* `firewalld_config.DefaultZone`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `public`.

* `firewalld_config.CleanupOnExit`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `true`.

* `firewalld_config.Lockdown`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `true`.

* `firewalld_config.IPv6_rpfilter`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `true`.

* `firewalld_config.IndividualCalls`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `false`.

* `firewalld_config.LogDenied`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `off`.

* `firewalld_config.FirewallBackend`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `nftables`.

* `firewalld_config.FlushAllOnReload`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `true`.

* `firewalld_config.RFC3964_IPv4`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `true`.

* `firewalld_config.AllowZoneDrifting`

See the [official Firewalld documentation](https://firewalld.org/documentation/configuration/firewalld-conf.html). Defaults to `false`.

## Example Playbook

```yaml
- hosts: all
  vars:
    firewalld_service_enabled: true
    firewalld_service_state: started
    firewalld_config:
      FirewallBackend: nftables
    firewalld_rules:
      # permanent rules
      - service: ssh
        zone: public
      - service: https
        zone: public
      - service: http
        zone: public

      # temporary rule
      - port: 222/tcp
        zone: trusted
        permanent: false
        state: enabled

      # disable rule
      - service: ftp
        zone: public
        state: disabled
```

Service definitions for xml templates:

```yaml
firewalld_services:
  - name: ""
    short: ""
    description: ""
    port: []
    protocol: []
    source_port: []
    module: []
    destination: {}
```

Zone definitions for xml templates:

```yaml
firewalld_zones:
  - name: ""
    short: ""
    description: ""
    target: ""
    interface:
      - name: ""
    source:
      - address: ""
      - mac: ""
      - ipset: ""
    service:
      - name: ""
    port:
      - { port: "", protocol: "" }
    protocol:
      - value:
    icmp-block:
      - name:
    icmp-block-inversion: true
    masquerade: true
    forward-port:
      - { port: "", protocol: "" }
    source-port:
      - { port: "", protocol: "" }
    rule:
      - source:
          address: ""
          mac: ""
          ipset: ""
        destination:
          ""
        service:
          name: ""
        port:
          port: ""
          protocol: ""
        protocol:
          value: ""
        icmp-block:
          name: ""
        icmp-type:
          name: ""
        masquerade: true
        forward-port:
          port: ""
          protocol: ""
          to-port: ""
          to-addr: ""
        source-port:
          port: ""
          protocol: ""
        log:
          prefix: ""
          level: ""
          limit: ""
        audit:
          limit: ""
        accept:
          limit: ""
        reject:
          rejecttype: ""
          limit: ""
        drop:
          limit: ""
        mark:
          set:
          limit: ""
```

Service definitions for xml templates:

```yaml
firewalld_services:
  - name: myservice
    short: "MYSERVICE"
    description: "My custom service"
    port:
      - port: 123
        protocol: tcp
```
