Ansible role: Networking
========================

Adapted from: https://github.com/wandansible/networking.git

Configure and apply networking interface configuration (including VLANs, and WiFi)
with either ifupdown or netplan depending on which is installed on the host system.

Requirements
------------

To use this role, the python package `netaddr` must be installed on the host running ansible.

Role Variables
--------------

```
ENTRY POINT: main - Configure networking interfaces with ifupdown or netplan

        Configure and apply networking interface configuration
        (including VLANs, and WiFi) with either ifupdown or netplan
        depending on which is installed on the host system.

OPTIONS (= is mandatory):

- netplan_renderer
        Networking backend to use for netplan
        choices: [networkd, NetworkManager, sriov]
        default: networkd
        type: str

- network_dad_attempts
        Number of attempts to settle DAD (0 to disable DAD)
        default: 100
        type: int

- network_interfaces
        List of network interfaces to configure
        default: null
        elements: dict
        type: list

        OPTIONS:

        - access_points
            List of wireless networks to configure
            default: null
            elements: dict
            type: list

            OPTIONS:

            - identity
                The identity to use for EAP
                default: null
                type: str

            - key-management
                Key management mode
                choices: [none, psk, eap]
                default: psk
                type: str

            - method
                The EAP method to use
                choices: [tls, peap, ttls]
                default: null
                type: str

            - password
                The password string for EAP, or the pre-shared key for
                WPA-PSK
                default: null
                type: str

            - phase2-auth
                The phase 2 auth mechanism
                default: null
                type: str

            - ssid
                SSID
                default: null
                type: str

        - allow
            Subsystem the interface should be brought up by (ifupdown
            only)
            default: null
            type: str

        - bridge_ports
            Interfaces to add to bridge
            default: null
            elements: str
            type: list

        - bridge_waitport
            Time in seconds to wait for bridge ports to come up
            default: null
            type: int

        - dns_nameservers
            List of DNS resolver IP addresses
            default: null
            elements: str
            type: list

        - dns_search
            List of DNS search domains
            default: null
            elements: str
            type: list

        - families
            List of IP address families to configure
            default: null
            elements: dict
            type: list

            OPTIONS:

            - address
                Static IP address for interface
                default: null
                type: str

            - gateway
                Default gateway
                default: null
                type: str

            = name
                IP address family
                choices: [ipv4, ipv6]
                type: str

            = type
                IP address autoconfiguration source
                choices: [static, dhcp, auto, manual]
                type: str

        - match_mac
            Apply configuration by matching MAC address instead of
            interface name (netplan only)
            default: null
            type: str

        - mtu
            Interface MTU
            default: null
            type: int

        = name
            Interface name
            type: str

        - vlans
            List of VLAN interfaces to configure
            default: null
            elements: dict
            type: list

            OPTIONS:

            - access_points
                List of wireless networks to configure
                default: null
                elements: dict
                type: list

                OPTIONS:

                - identity
                    The identity to use for EAP
                    default: null
                    type: str

                - key-management
                    Key management mode
                    choices: [none, psk, eap]
                    default: psk
                    type: str

                - method
                    The EAP method to use
                    choices: [tls, peap, ttls]
                    default: null
                    type: str

                - password
                    The password string for EAP, or the pre-shared key
                    for WPA-PSK
                    default: null
                    type: str

                - phase2-auth
                    The phase 2 auth mechanism
                    default: null
                    type: str

                - ssid
                    SSID
                    default: null
                    type: str

            - allow
                Subsystem the interface should be brought up by
                (ifupdown only)
                default: null
                type: str

            - bridge_ports
                Interfaces to add to bridge
                default: null
                elements: str
                type: list

            - bridge_waitport
                Time in seconds to wait for bridge ports to come up
                default: null
                type: int

            - dns_nameservers
                List of DNS resolver IP addresses
                default: null
                elements: str
                type: list

            - dns_search
                List of DNS search domains
                default: null
                elements: str
                type: list

            - families
                List of IP address families to configure
                default: null
                elements: dict
                type: list

                OPTIONS:

                - address
                    Static IP address for interface
                    default: null
                    type: str

                - gateway
                    Default gateway
                    default: null
                    type: str

                = name
                    IP address family
                    choices: [ipv4, ipv6]
                    type: str

                = type
                    IP address autoconfiguration source
                    choices: [static, dhcp, auto, manual]
                    type: str

            = id
                VLAN ID
                type: int

            - mtu
                Interface MTU
                default: null
                type: int

            = waitonboot
                If true, wait for interface to come up before booting
                type: bool

        = waitonboot
            If true, wait for interface to come up before booting
            type: bool

- network_tune
        If true, enable network tuning
        default: false
        type: bool

- network_tune_interface
        Override the automatic detection of which network interface to
        use for setting tuning values
        default: null
        type: str

- network_tune_sysctls
        List of sysctls that should be applied for different interface
        speeds
        default: null
        elements: dict
        type: list

        OPTIONS:

        = min_speed
            Minimum network interface speed (in megabits per second)
            for which these sysctls should apply
            type: int

        = sysctls
            List of sysctls to set
            elements: dict
            type: list

            OPTIONS:

            = key
                Name of sysctl
                type: str

            = value
                Value of sysctl
                type: str

- network_wait_on_change
        If true, wait for user to accept any network configuration
        changes before continuing and applying the changes
        default: true
        type: bool
```

Installation
------------

This role can either be installed manually with the ansible-galaxy CLI tool:

    ansible-galaxy install git+https://github.com/wandansible/networking,main,wandansible.networking
     
Or, by adding the following to `requirements.yml`:

    - name: wandansible.networking
      src: https://github.com/wandansible/networking

Roles listed in `requirements.yml` can be installed with the following ansible-galaxy command:

    ansible-galaxy install -r requirements.yml

Example Playbook
----------------

    - hosts: all
      roles:
        - role: wandansible.networking
          become: true
          vars:
            network_interfaces:
              - name: "eno1"
                waitonboot: true
                families:
                  - name: ipv4
                    type: dhcp
                  - name: ipv6
                    type: auto

    - hosts: complex_host
      roles:
        - role: wandansible.networking
          become: true
          vars:
            network_interfaces:
              - name: eno1
                waitonboot: true
                families:
                  - name: ipv4
                    type: manual
                vlans:
                  - id: 2405
                    waitonboot: true
                    dns_nameservers:
                      - "8.8.8.8"
                      - "8.8.4.4"
                    dns_search:
                      - "example.org"
                    families:
                      - name: ipv4
                        type: static
                        address: "192.0.2.1/24"
                        gateway: "192.0.2.254"
                      - name: ipv6
                        type: static
                        address: "2001:db8::1/64"
                        gateway: "2001:db8::ffff"
              - name: eno2
                waitonboot: false
                families:
                  - name: ipv4
                    type: static
                    address: "192.168.0.1/24"

    - hosts: wifi_host
      roles:
        - role: wandansible.networking
          become: true
          vars:
            network_interfaces:
              - name: "wlan0"
                waitonboot: false
                families:
                  - name: ipv4
                    type: dhcp
                  - name: ipv6
                    type: auto
                access_points:
                   - ssid: "open-with-password"
                     password: "presharedkey123"
              - name: "wlan1"
                waitonboot: false
                families:
                  - name: ipv4
                    type: dhcp
                  - name: ipv6
                    type: auto
                access_points:
                   - ssid: "more-auth-required"
                     key-management: "eap"
                     method: "peap"
                     phase2-auth: "MSCHAPV2"
                     identity: "user@institution"
                     password: "password123"
