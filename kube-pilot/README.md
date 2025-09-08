# KubePilot
AI-Driven Kubernetes Orchestration with MCP (k3s, Docker, AWS EC2, Amazon Q)

## Tech
k3s, Docker, AWS EC2, Amazon Q, MCP Server, CoreDNS, HPA, YAML, Bash

## What this repo contains
- Example Node.js app + Dockerfile
- k3s/Kubernetes manifests (Deployment, Service, Ingress, HPA)
- Example `mcp-config.json` for Amazon Q MCP integration
- Helper scripts to provision k3s and deploy app
- Basic GitHub Actions CI workflow (build)

## Quick start (local / dev)
1. Build the Docker image:
   ```bash
   docker build -t kube-pilot-example:latest ./docker
   ```
2. Start a k3s cluster locally (or use Docker Desktop / remote k8s).
3. Deploy manifests:
   ```bash
   kubectl apply -f k8s-manifests/
   ```
4. (Optional) Run MCP servers locally:
   ```bash
   ./scripts/run-mcp-servers.sh
   ```
5. Add the example `mcp/mcp-config.json` to your Amazon Q config.

## Notes
- This is a starter scaffolding. Do not expose MCP servers publicly without securing them (TLS, auth).
- Replace placeholders (image names, domain names, cloud-init) before production use.
