#!/usr/bin/env bash
set -euo pipefail
# Simple k3s install script for Ubuntu-based EC2. Review before use.
if ! command -v curl >/dev/null 2>&1; then
  apt-get update && apt-get install -y curl
fi
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.27.7+k3s1 sh -
echo "k3s installed. kubectl is available at /usr/local/bin/kubectl (or use kubectl via k3s)."
