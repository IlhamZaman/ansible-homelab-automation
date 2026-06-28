# Ansible Homelab Automation 

I used Ansible to automate the management of my Linux virtual machines. It handles tasks such as backing up important config files, updating virtual machines, checking whether a reboot is needed, and rebooting the systems. 

## Architecture

- Hypervisor: Proxmox Virtual Environment 
- Control Node: AlmaLinux 9 Management VM
- Managed Services:
  - Proxmox VE Hypervisor
  - Management VM
  - Cloudflare Gateway VM (Ubuntu Server 26.04)
  - TrueNAS Scale
  - Jellyfin VM (Debian 13.4)
  - Personal Minecraft Server VM (Debian 13.4)
  - Technitium DNS VM (openSUSE Leap)
  - Uptime Kuma / Homepage VM (Fedora Workstation 44)
- Network: Private homelab LAN with no public SSH exposure
- Remote Access: Local SSH access in AlmaLinux through SSH keys only

## Inventory Groups

| Group | Purpose |
|---|---|
| `proxmox_hosts` | Proxmox VE Hypervisor |
| `management_vm` | AlmaLinux Management VM running Ansible & Terraform |
| `truenas_servers` | TrueNAS |
| `ubuntu_servers` | Ubuntu-based services such as `cloudflared` |
| `debian_servers` | Debian-based services such as Jellyfin |
| `fedora_servers` | Fedora-based services such as Uptime Kuma / Homepage |
| `opensuse_servers` | openSUSE-based services such as Technitium DNS |

## Playbooks

| Playbook | What it does | Homelab use case |
|---|---|---|
| `baseline-packages.yml` | Installs basic tools on all managed Linux systems | Helps with replicating systems quickly |
| `install-qemu-agent.yml` | Installs and starts the QEMU Guest Agent on managed Linux systems | Allows for better VM management |
| `health-check.yml` | Checks uptime, disk, memory, and failed services on all managed Linux systems | Quick VM health overview |
| `truenas-health-check.yml` | Checks TrueNAS middleware readiness, version, and active alerts. | Quick TrueNAS health overview |
| `check-services.yml` | Checks status of important services on all managed Linux systems | Verifies Proxmox services, cloudflared, nginx, Homepage, Uptime Kuma, Jellyfin, and Technitium DNS are running (Maintenance Related) |
| `backup-configs.yml` | Backs up important configuration files from Hypervisor and managed VMs | Keeps copies of SSH, hostname, fstab, and service configs (Maintenance Related) |
| `update-all.yml` | Updates packages on all managed systems | Keeps homelab Hypervisor & VMs patched (Maintenance Related) |
| `update-DISTRO/PACKAGE-MANAGER-NAME.yml` | Updates packages on Proxmox VE and all managed Virtual Machines | Keeps homelab Hypervisor & VMs patched (Maintenance Related) |
| `reboot-report.yml` | Checks uptime/reboot status after maintenance | Confirms systems came back online properly (Maintenance Related) |
| `reboot-proxmox.yml` | Reboots Hypervisor safely | Used for controlled maintenance windows (Maintenance Related) |
| `reboot-truenas.yml` | Reboots TrueNAS VM safely | Used for controlled maintenance windows (Maintenance Related) |
| `reboot-vms.yml` | Reboots selected Linux VMs safely | Used for controlled maintenance windows (Maintenance Related) |



## Scripts (Playbook Commands Combined for Cleanliness)
| Script | What it does | 
|---|---|
| `maintenance.sh` | Executes the general maintenance-related playbooks together |
| `reboot-pve.sh` | Runs Proxmox VE reboot playbook |
| `reboot-truenas.sh` | Runs TrueNAS VM reboot playbook |
| `reboot-management.sh` | Runs Management VM reboot playbook |
