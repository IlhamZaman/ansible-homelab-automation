#!/bin/bash
set -euo pipefail

cd ~/homelab/ansible

echo "=== Rebooting TrueNAS ==="
ansible-playbook playbooks/reboot-truenas.yml -e confirm_truenas_reboot=true
