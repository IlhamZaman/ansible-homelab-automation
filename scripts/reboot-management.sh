#!/bin/bash
set -euo pipefail

cd ~/homelab/ansible

echo "=== Rebooting AlmaLinux Management VM ==="
ansible-playbook playbooks/reboot-management.yml -e confirm_management_reboot=true
