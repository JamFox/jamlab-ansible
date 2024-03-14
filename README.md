<p align="center">
  <a href="https://jamfox.dev">
    <img alt="JF" src="https://raw.githubusercontent.com/JamFox/wired.jamfox.dev/main/src/android-chrome-192x192.png" width="60" />
  </a>
</p>
<h1 align="center">
JamLab Ansible Management Monorepo
</h1>

Ansible playbooks for configuration management in push mode.

## Current status of unfinished roles

❌ - false

✔️ - true

**Complete** - role is implemented and conceptually in a finished state. May contain errors or bugs if dry-test and real test have not been performed.

**Dry-test** - role has been tested in a dry-run mode and did not error.

**Real-Test** - role has been tested in a real environment and did not error.

| Role             | Complete | Dry-Test | Real-Test |
| ---------------- | -------- | -------- | --------- |
| mounts_exports   | ✔️        | ✔️        | ❌         |
| networking       | ✔️        | ✔️        | ❌         |
| nfs              | ❌        | ❌        | ❌         |

## Usage

Before all, set the Ansible Vault password in home: `vim ~/.ansible-vault-pass`

Then install collection requirements (not needed when using [ansible-parallel](https://github.com/JamFox/ansible-parallel) which already does this):

```bash
ansible-galaxy collection install -r requirements.yml
```

Then use ansible-playbook or [ansible-parallel](https://github.com/JamFox/ansible-parallel) bash script to run playbooks.

### Jumphost configuration

To use a jumphost (for example from your local machine over base):

1. Go to `hosts` file
2. Uncomment the `ansible_ssh_common_args` variable under [all:vars]
3. Uncomment later when you have finished testing locally or run `git checkout hosts`

### Override remote user

All playbooks set their default remote user used by the automatic scheduled system like so:

```yaml
remote_user: ansible
```

If you do not have access to this user directly then override the remote_user variable with the following flag: `-e 'ansible_user=<YOUR USER HERE>'`

### Host inventory / Creating group playbooks

Each host should belong to **ONE** group to preserve readability.

To create a new group:

1. Add it to the `hosts` inventory file:

```ini
[<HOST GROUP NAME>]
<HOSTNAME>            ansible_host=<HOST IP>
```

2. Create a playbook directory under `playbooks/` directory and define list of roles in the file `playbooks/<PLAYBOOK NAME>/main.yml`.

### Disabling roles

Disabled roles can still be defined in playbooks but will be skipped on runs. Useful for when the role is in a bad/incomplete state but it is desirable to define the order of execution or add it to list of roles for the future.

To disable a role, define it in `playbooks/vars_disabled_roles.yml`:

```yml
disabled_roles:
  # rrr disabled reason - <your reason here>
  rrr: true
```

For info, add a comment with reasons why the role is disabled.

### Variable precedence

Ansible does apply [variable precedence](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence) for the 22 different places you can configure variables. For this repository, we only need to know about 6, for which the order of precedence from least to greatest (the variables listed last override/replace all other variables) is as follows:

1. Role defaults (defined in `roles/<ROLE NAME>/defaults/main.yml`)
2. [Inventory file variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#adding-variables-to-inventory)
3. Playbook group vars (defined in `playbooks/<PLAYBOOK NAME>/group_vars/all.yml`)
4. Playbook host vars (defined in `playbooks/<PLAYBOOK NAME>/host_vars/<HOST NAME>.yml`)
5. Playbook vars files (included in `playbooks/<PLAYBOOK NAME>/main.yml` using `vars_files:`)
6. Extra vars (defined in command line using `-e EXTRA_VARS, --extra-vars EXTRA_VARS` flags)

### Common variables

Common variables should be defined in files under `playbooks/` and imported with `vars_files` list.

For example `playbooks/vars_common_all.yml` contains variables that every single host needs access to. Then the file is imported inside the playbook `playbooks/group_ggg_example/main.yml` as follows:

```yml
- name: PLAYBOOK FOR GROUP 'GGG_EXAMPLE'
  hosts: ggg_example
  vars_files:
    - ../vars_common_all.yml
    - ../vars_disabled_roles.yml
```

### Combine group and host vars

After the announcement of deprecating `hash_behaviour=merge` option in Ansible it is no longer possible to implicitly combine dictionaries with same names in role, group and host variables. Instead separate dictionaries should be defined and then combined as needed, this is more explicit and improves readability.

### Using secrets

AVOID COMMITING PLAINTEXT SECRETS, USE ANSIBLE-VAULT!

Using [`ansible-vault`](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html) it is possible to create encrypted variables and files that can be commited to the repository.

In `ansible.cfg` the `vault_password_file` variable defines in which file the ansible-vault password should be defined in.

Once the vault password file is set up you can use ansible-vault as follows:

Secret variables can be set by encrypting strings:

```bash
ansible-vault encrypt_string password123 
```

And pasting the output in place of a variable:

```yaml
my_password: !vault |
    $ANSIBLE_VAULT;1.1;AES256
    66386439653236336347626566653063336164663966303231363934653561363964363833
    3136626431626536303530376336343832656537303632313433360a626438346336353331
```

View encrypted variable with:

```bash
ansible localhost \
       -m debug \
       -a "var=<VAR NAME>" \
       -e "@<PATH TO VAR FILE>"
```

Encrypt files with:

```bash
ansible-vault encrypt encrypt_me.txt
```

View encrypted files with:

```bash
ansible-vault view encrypt_me.txt
```

Edit encrypted files with:

```bash
ansible-vault edit encrypt_me.txt
```

Decrypt encrypted files with:

```bash
ansible-vault decrypt encrypt_me.txt
```

### Playbook structure

Each playbook in `playbooks/`:

- has a name starting with:
  - `group_` (if it is applied to a group of machines)
  - `host_` (if it is applied to one host)
  - `function_` (if it is applied to a functionality).
- has a file named `main.yml` to describe the playbook with tasks and roles.
- may have a `group_vars/all.yml` to set the default values of variables for all hosts executing the playbook.
- may have a `host_vars/hhh.yml` to overwrite some variable values for that host `hhh` executing the playbook.
- may have multiple vars files imported with `vars_files` to include variable files that are common to some groups or hosts.
- does **NOT** have a role directory as it is outside of the playbook.
- does **NOT** have the `ansible.cfg` configuration file since it is one level upper.

Template structure of the playbooks:

```yml
playbooks/
  vars_common_all.yml
  vars_disabled_roles.yml
  group_ggg/
    main.yml
    group_vars/
      all.yml
  host_hhh/
    main.yml
    host_vars/
      hhh.yml
  function_fff/
    main.yml
```

Example structure of playbook `playbook/ppp/main.yml`:

```yml
- name: PLAYBOOK FOR GROUP 'GGG'
  hosts: ggg
  vars_files:
    - ../vars_common_all.yml
    - ../vars_disabled_roles.yml

  roles:

  - { role: pre, tags: [ pre ], when: not (disabled_roles.pre | default(false)) }
  - { role: rrr, tags: [ rrr ] }
  - { role: post, tags: [ post ] }
```

It is possible to disable a role for  host `hhh` for example, by defining in `playbooks/group_ggg/host_vars/hhh.yml`:

```yml
disabled_roles:
  rrr: true
```

Use `vars_files` to include variable files that are common to some groups or hosts.

### Role structure

Each role in `roles/` can be used in any playbook in `playbooks/ppp/main.yml`.

Structure of a role:

```yml
roles/
  <ROLE NAME>/
    tasks/      # Tasks of role
    defaults/   # Default variables are defined here
    files/      # Files and templates
    handlers/   # Handler tasks
    README.md   # Role usage info and explanations
```

## Conventions and best practices

### Developing, additions

Before all, **keep it simple**. If you need something specific configured, create a role that simply does it without complicated logic or variable handling. Add complexity only as other hosts need more different configurations.
For example, mounts and exports are usually unique to host groups, as such it requires a more complex generic logic to handle multiple different mounts and exports. But on the other hand when configuring a single bind DNS server, the logic can be much more simpler, if there is only one DNS server then the role can be made without complex variable handling.

All updates should be done in a separate branch, tested and then merged into the `master` branch.

Naming for branches should use the following convention: `<topic>/<short description>`. Example: `role/firewalld` or `playbook/group_training`.

### Style

When registering output of a command, use the `register` keyword and save the output variable name prefixed with `r_`. Example:

```yml
- name: Check for sudo
  ansible.builtin.stat: path=/etc/sudoers
  register: r_sudoers

- name: Install sudo block
  when: not r_sudoers.stat.exists
```

When using `block` of tasks, define `when` condition right under the `name` remove spaces from the tasks to make it more readable. Example:

```yml
- name: Install Zabbix for CentOS/RedHat
  when: ansible_os_family in ['CentOS', 'RedHat']
  block:
    - name: Add Zabbix repo
      ansible.builtin.yum:
        name: https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
        state: present
    - name: Install Zabbix agent
      ansible.builtin.yum:
        name: "{{ zabbix_agent_packages }}"
        state: latest
```

### Files and templates

Comment Ansible-managed files with `# Managed by Ansible, do not edit manually - changes made here will be overwritten!` at the top. Use the `ansible_managed` variable to render the comment using jinja. Do not suffix files with `jinja` if they do not include any other logic besides including the comment variable.

"Unhide" dot files with the prefix `dot_`. For example, `.bashrc` should be named `dot_bashrc`.

`jinja` templates which should be suffixed with `.jinja` and not `.j2`.

## Naming

- In Git, names are merged with a dash ('-'), such as jamlab-ansible. This is for historical reasons.
- In Ansible, names are merged with an underscore ('_'), such as group_vars or host_vars.
- In Linux, names are merged with a dash ('-'), such as NetworkManager-wait-online.service or system-auth.
