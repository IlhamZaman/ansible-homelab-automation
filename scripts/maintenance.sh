#!/bin/bash
set -e

cd ~/homelab/ansible

echo "=== Running health check ==="
ansible-playbook playbooks/health-check.yml

echo "=== Backing up configs ==="
ansible-playbook playbooks/backup-configs.yml

echo "=== Updating all Linux VMs ==="
ansible-playbook playbooks/update-all.yml

echo "=== Checking services ==="
ansible-playbook playbooks/check-services.yml

echo "=== Checking reboot requirements ==="
ansible-playbook playbooks/reboot-report.yml

echo "=== Maintenance complete ==="
