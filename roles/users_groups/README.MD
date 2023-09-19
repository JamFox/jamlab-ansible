# Role to manage users and groups

This role configures users and groups. Supports:

* list of users to add
* create groups based on users configuration
* configuring sudoers for users
* configuring ssh authorized_keys for users

**WARNING!**: take care when running this role on users that exist before the run, existing setting WILL be overridden, make sure nothing is missing from your defined variables BEFORE running this role.

## Role variables

* `users`

Dict of users to configure. Example:

```yaml
users:
  - name: ''                           # username
    gecos: ''                          # comment
    homedir: ''                        # homedir
    uid: ''                            # uid
    primary_gid: ''                    # primary group's gid
    groups: []                         # other groups
    no_create_home: false              # If true, do not create a home directory. Defaults to true if `system: true`.
    shell: "{{ users_default_shell }}" # shell
    passwd: ''                         # A SHA512 hashed and salted password
    ssh_authorized_keys: []            # ssh pub keys to add to add auth_keys
    sudo: ''                           # sudo string 
    system: false                      # If true, the user will be a system user. This does not affect existing users.
```

* `users_deleted`

Dict of users to delete. Example:

```yaml
users_deleted:
        - name: ''
        - name: ''
```