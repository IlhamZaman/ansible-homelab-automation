# Ansible Homelab Automation

Automated infrastructure management lab running on AlmaLinux 9 built for my Proxmox-based homelab.  
I used Ansible to automate the management of my Linux virtual machines. It handles things such as backing up the important config files, updating the virtual machines, checking if a reboot is needed, and then rebooting the systems. 

## Architecture

- Hypervisor: Proxmox Virtual Environment 
- Control Node: AlmaLinux Management VM
- Managed Nodes:
  - Cloudflare Gateway VM (Ubuntu Server 26.04)
  - Jellyfin VM (Debian 13.4)
  - Technitium DNS VM (openSUSE Leap)
  - Kuma / Homepage VM (Fedora Workstation 44)
- Network: Private homelab LAN with no public SSH exposure
- Remote Access: Cloudflare Tunnel where needed

## Inventory Groups

| Group | Purpose |
|---|---|
| `ubuntu_servers` | Ubuntu-based services |
| `debian_servers` | Debian-based services such as Jellyfin |
| `fedora_servers` | Fedora-based services such as Uptime Kuma / Homepage |
| `opensuse_servers` | openSUSE-based services such as Technitium DNS |

## Playbooks

| Playbook | What it does | Homelab use case |
|---|---|---|
| `backup-configs.yml` | Backs up important configuration files from managed VMs | Keeps copies of SSH, hostname, fstab, and service configs |
| `reboot-vms.yml` | Reboots selected Linux VMs safely | Used for controlled maintenance windows |
| `reboot-report.yml` | Checks uptime/reboot status after maintenance | Confirms systems came back online properly |
| `ssh-hardening.yml` | Applies SSH security improvements | Reduces risky SSH settings across VMs |
| `system-update.yml` | Updates packages on managed Linux systems | Keeps homelab VMs patched |
| `maintenance.yml` | Runs basic cleanup and maintenance tasks | Helps keep systems stable and clean |

## Example Inventory

```ini
[debian_servers]
jellyfin ansible_host=LOCAL-IP

[fedora_servers]
kuma-homepage ansible_host=LOCAL-IP

[opensuse_servers]
technitium ansible_host=LOCAL-IP

[ubuntu_servers]
cloudflare-gateway ansible_host=LOCAL-IP
