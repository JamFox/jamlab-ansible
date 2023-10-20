# Role to manage Proxmox VE

1. Disables [Proxmox VE Enterprise Repository](https://pve.proxmox.com/wiki/Package_Repositories#sysadmin_enterprise_repo) to prevent errors without Enterprise subscription key
    - NOTE: this is not done using `soft_apt` role because that role does not handle removing unmanaged repos
    - NOTE: removed PVE Enterprise repo needs to be replaced by the PVE no-subscription repo instead, this is handled using `soft_apt` role in group vars
2. Install extra packages needed for our cluster
