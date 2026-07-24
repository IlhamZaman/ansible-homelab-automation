#!/bin/bash
set -euo pipefail

cd /home/izaman/homelab/ansible

export ANSIBLE_CONFIG="$(pwd)/ansible.cfg"

echo "=== Running Proxmox VE, Linux VMs, and Management VM health check ==="
ansible-playbook playbooks/health-check.yml

echo "=== Running TrueNAS health check ==="
ansible-playbook playbooks/truenas-health-check.yml

echo "=== Backing up Proxmox VE, Linux VMs, and Management VM configs ==="
ansible-playbook playbooks/backup-configs.yml

echo "=== Updating Proxmox VE, Linux VMs, and Management VM ==="
ansible-playbook playbooks/update-proxmox.yml
ansible-playbook playbooks/update-fedora.yml
ansible-playbook playbooks/update-opensuse.yml
ansible-playbook playbooks/update-apt.yml
ansible-playbook playbooks/update-management.yml

echo "=== Applying TrueNAS updates if available ==="
ansible-playbook playbooks/update-truenas.yml \
  -e truenas_apply_updates=true \
  -e truenas_reboot_after_update=true

echo "=== Checking services ==="
ansible-playbook playbooks/check-services.yml

echo "=== Checking reboot requirements ==="
ansible-playbook playbooks/reboot-report.yml

echo "=== Maintenance complete ==="
