#!/usr/bin/env bash
set -euo pipefail
IMAGE_NAME="${IMAGE_NAME:-kube-pilot-example:latest}"
echo "Deploying image $IMAGE_NAME to cluster..."
# If using local image in k3s, you may need to load it into the node(s) or push to registry.
kubectl apply -f k8s-manifests/
echo "Deployment applied."
