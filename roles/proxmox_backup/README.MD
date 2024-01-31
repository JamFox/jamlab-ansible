# Role to manage Proxmox VE

1. Disables [Proxmox Backup Enterprise Repository](https://pbs.proxmox.com/docs/installation.html#proxmox-backup-no-subscription-repository) to prevent errors without Enterprise subscription key
    - NOTE: this is not done using `soft_apt` role because that role does not handle removing unmanaged repos
    - NOTE: removed PVE Enterprise repo needs to be replaced by the PVE no-subscription repo instead, this is handled using `soft_apt` role in group vars
