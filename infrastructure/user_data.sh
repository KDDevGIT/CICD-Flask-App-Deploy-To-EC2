#!/bin/bash
#cloud-config
# Bootstraps Docker on Amazon Linux 2023 so the Actions job can deploy immediately.

set -euo pipefail

# Update and install docker
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user || true

# Open firewall (Amazon Linux typically uses iptables; if using Ubuntu, adapt accordingly)
# For AL2023 + default security groups this is usually enough; SG already allows 80.
