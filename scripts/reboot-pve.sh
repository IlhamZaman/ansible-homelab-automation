#!/bin/bash
set -euo pipefail

cd ~/homelab/ansible

echo "=== Rebooting Proxmox VE ==="
ansible-playbook playbooks/reboot-proxmox.yml -e confirm_proxmox_reboot=true
