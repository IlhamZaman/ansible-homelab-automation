# Ansible Homelab Automation 

I used Ansible to automate the management of my Linux virtual machines. It handles tasks such as backing up important config files, updating virtual machines, checking whether a reboot is needed, and rebooting the systems. 

## Architecture

- Hypervisor: Proxmox Virtual Environment 
- Control Node: AlmaLinux 9 Management VM
- Managed Nodes:
  - Cloudflare Gateway VM (Ubuntu Server 26.04)
  - Jellyfin VM (Debian 13.4)
  - Technitium DNS VM (openSUSE Leap)
  - Kuma / Homepage VM (Fedora Workstation 44)
- Network: Private homelab LAN with no public SSH exposure
- Remote Access: Local SSH access in AlmaLinux through SSH keys only

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
| `backup-configs.yml` | Backs up important configuration files from managed VMs | Keeps copies of SSH, hostname, fstab, and service configs (Maintenance Related) |
| `reboot-vms.yml` | Reboots selected Linux VMs safely | Used for controlled maintenance windows (Maintenance Related) |
| `reboot-report.yml` | Checks uptime/reboot status after maintenance | Confirms systems came back online properly (Maintenance Related) |
| `update-all.yml` | Updates packages on all managed Linux systems | Keeps homelab VMs patched (Maintenance Related) |
| `health-check.yml` | Checks uptime, disk, memory, and failed services on all managed Linux systems | Quick VM health overview |
| `baseline-packages.yml` | Installs basic tools on all managed Linux systems | Helps with replicating systems quickly |
| `install-qemu-agent.yml` | Installs and starts the QEMU Guest Agent on managed Linux systems | Allows for better VM management |
| `check-services.yml` | Checks status of important services on all managed Linux systems | Verifies cloudflared, nginx, Homepage, Uptime Kuma, Jellyfin, and Technitium DNS are running (Maintenance Related) |



## Scripts
| Script | What it does | 
|---|---|
| `maintenance.sh` | Executes the maintenance-related playbooks together |
