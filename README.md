# Ansible Homelab Automation 

I used Ansible to automate the management of my Hypervisor, TrueNAS, Linux virtual machines, and Linux containers. It handles tasks such as backing up important configuration files, updating systems, checking service health, determining whether a reboot is needed, and safely rebooting systems during maintenance.

## Architecture

- Hypervisor: Proxmox Virtual Environment 
- Control Node: AlmaLinux 9 Management VM
- Managed Services:
  - Proxmox VE Hypervisor
  - Monitoring LXC
  - AlmaLinux Management VM
  - Cloudflare Gateway VM (Ubuntu Server 26.04)
  - Hermes Agent VM (Ubuntu Server 26.04)
  - TrueNAS SCALE
  - Jellyfin VM (Debian 13.4)
  - Immich VM (Debian 13.4)
  - Personal Minecraft Server VMs (Debian 13.4)
  - Technitium DNS VM (openSUSE Leap)
  - Uptime Kuma / Homepage VM (Fedora Workstation 44)
- Network: Private homelab LAN with no public SSH exposure
- Remote Access: Local SSH access through SSH keys only
- SSH Verification: Strict SSH host-key checking using a dedicated Ansible `known_hosts` file

## Inventory Groups

| Group | Purpose |
|---|---|
| `proxmox_hosts` | Proxmox VE Hypervisor |
| `management_vm` | AlmaLinux Management VM running Ansible and Terraform |
| `truenas_servers` | TrueNAS SCALE VM |
| `ubuntu_servers` | Ubuntu-based services such as Nginx and `cloudflared` |
| `hermes_servers` | Ubuntu-based Hermes Agent VM |
| `debian_servers` | Debian-based services such as Jellyfin, Immich, and Minecraft |
| `monitoring_servers` | Debian LXC running Prometheus, Grafana, and monitoring exporters |
| `fedora_servers` | Fedora-based services such as Uptime Kuma and Homepage |
| `opensuse_servers` | openSUSE-based services such as Technitium DNS |
| `linux_servers` | Combined Ubuntu, Debian, Fedora, and openSUSE systems |
| `linux_maintenance_targets` | Linux systems, Proxmox, Monitoring LXC, and Management VM |
| `maintenance_targets` | All systems included in the maintenance workflow |

## Playbooks

| Playbook | What it does | Homelab use case |
|---|---|---|
| `baseline-packages.yml` | Installs basic tools on managed Linux systems | Helps with quickly preparing and replicating systems |
| `install-qemu-agent.yml` | Installs and starts the QEMU Guest Agent on managed Linux VMs | Allows for better VM monitoring and management through Proxmox |
| `health-check.yml` | Checks uptime, disk usage, memory usage, and failed services on managed Linux systems | Provides a quick health overview of VMs and LXCs |
| `truenas-health-check.yml` | Checks TrueNAS middleware readiness, version, and active alerts | Provides a quick TrueNAS health overview |
| `check-services.yml` | Checks the status of important services on managed systems | Verifies Proxmox, Nginx, Cloudflare Tunnel, Homepage, Uptime Kuma, Jellyfin, Technitium DNS, Prometheus, Grafana, and exporters are running |
| `backup-configs.yml` | Backs up important configuration files from the Hypervisor, managed VMs, and LXCs | Keeps copies of SSH, hostname, fstab, service, Minecraft, and application configurations |
| `update-all.yml` | Runs the individual update playbooks for all managed systems | Keeps the Hypervisor, VMs, LXC, TrueNAS, and Management VM patched |
| `update-apt.yml` | Updates Ubuntu and Debian-based systems | Keeps Ubuntu, Debian, Hermes, and Monitoring systems patched |
| `update-fedora.yml` | Updates Fedora-based systems | Keeps the Uptime Kuma / Homepage VM patched |
| `update-opensuse.yml` | Updates openSUSE-based systems | Keeps the Technitium DNS VM patched |
| `update-management.yml` | Updates the AlmaLinux Management VM | Keeps the Ansible and Terraform control node patched |
| `update-proxmox.yml` | Updates the Proxmox VE Hypervisor | Keeps the Hypervisor patched |
| `update-truenas.yml` | Checks for and optionally installs TrueNAS updates | Keeps TrueNAS SCALE patched |
| `reboot-report.yml` | Checks uptime and reboot requirements after maintenance | Confirms which systems require a reboot |
| `reboot-proxmox.yml` | Reboots the Proxmox VE Hypervisor after confirmation | Used for controlled Hypervisor maintenance windows |
| `reboot-truenas.yml` | Reboots the TrueNAS SCALE VM after confirmation | Used for controlled TrueNAS maintenance windows |
| `reboot-vms.yml` | Reboots selected Linux VMs and the Monitoring LXC after confirmation | Used for controlled VM and LXC maintenance windows |
| `reboot-management.yml` | Reboots the AlmaLinux Management VM after confirmation | Used for controlled Management VM maintenance |
| `reboot-hermes.yml` | Reboots the Hermes Agent VM after confirmation | Used for controlled Hermes maintenance |

## Scripts (Playbook Commands Combined for Cleanliness)

| Script | What it does |
|---|---|
| `maintenance.sh` | Executes the general maintenance-related playbooks together |
| `reboot-pve.sh` | Runs the Proxmox VE reboot playbook |
| `reboot-truenas.sh` | Runs the TrueNAS SCALE reboot playbook |
| `reboot-management.sh` | Runs the Management VM reboot playbook |
| `reboot-vms.sh` | Runs the Linux VM and LXC reboot playbook |

## Configuration

The included `inventory.ini` and `ansible.cfg` files use placeholders for private information such as:

- IP addresses
- SSH usernames
- SSH private-key filenames
- TrueNAS SSH key paths

Replace the placeholders locally before running the playbooks.

The Ansible configuration uses strict SSH host-key verification with a dedicated file:

```ini
[defaults]
inventory = inventory.ini
host_key_checking = True
retry_files_enabled = False
stdout_callback = default
interpreter_python = auto_silent
timeout = 20
private_key_file = ~/.ssh/SSH-KEY-HERE

[ssh_connection]
ssh_args = -o UserKnownHostsFile=~/.ssh/known_hosts_ansible -o StrictHostKeyChecking=yes
