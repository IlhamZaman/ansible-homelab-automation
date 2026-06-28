#!/bin/bash
set -euo pipefail

cd ~/homelab/ansible

echo "=== Rebooting Linux VMs ==="
ansible-playbook playbooks/reboot-vms.yml -e confirm_vm_reboot=true
