# KubePilot — AI-Driven Kubernetes Orchestration (Starter Repo)
---
````markdown
# KubePilot

AI-Driven Kubernetes Orchestration with MCP

**Tech:** k3s, Docker, AWS EC2, Amazon Q, MCP Server, CoreDNS, HPA, YAML

## What this repo contains
- Example Dockerfile for an app
- Kubernetes manifests (k3s-friendly) for Deployment, Service, Ingress, HPA
- Example `mcpServers` config to register MCP connectors with Amazon Q
- Simple helper scripts to run MCP servers locally with `npx` or `uvx`
- A GitHub Actions CI workflow (build & push image)

## Quick start (local dev)
1. Build the Docker image:
   ```bash
   docker build -t kube-pilot-example:latest ./app
````

2. Run a local k3s cluster (or use Docker Desktop Kubernetes).
3. Apply manifests:

   ```bash
   kubectl apply -f k8s/k3s-deploy.yaml
   ```
4. (Optional) Start an MCP server locally:

   ```bash
   ./scripts/run-mcp-servers.sh
   ```
5. Add MCP servers to your Amazon Q config using `mcp-config.json` as example.

## License

MIT

```
```

### `app/Dockerfile`

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

### `app/app.py` (simple placeholder web app)

```python
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type','text/plain')
        self.end_headers()
        self.wfile.write(b'KubePilot example app')

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), Handler)
    print('Listening on 0.0.0.0:8080')
    server.serve_forever()
```

### `app/requirements.txt`

```text
# minimal deps for example app
```

### `k8s/k3s-deploy.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubepilot-example
spec:
  replicas: 2
  selector:
    matchLabels:
      app: kubepilot
  template:
    metadata:
      labels:
        app: kubepilot
    spec:
      containers:
      - name: kube-pilot-app
        image: kube-pilot-example:latest
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        resources:
          limits:
            cpu: "250m"
            memory: "256Mi"
          requests:
            cpu: "100m"
            memory: "128Mi"
---
apiVersion: v1
kind: Service
metadata:
  name: kubepilot-service
spec:
  selector:
    app: kubepilot
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: ClusterIP
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: kubepilot-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: kubepilot-example
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
```

### `mcp-config.json` (example snippet for Amazon Q)

```json
{
  "mcpServers": {
    "kubernetes": {
      "command": "npx",
      "args": ["kubernetes-mcp-server@latest"]
    },
    "cdk": {
      "command": "npx",
      "args": ["cdk-mcp-server@latest"]
    }
  }
}
```

### `scripts/run-mcp-servers.sh`

```bash
#!/usr/bin/env bash
set -e
# start kubernetes mcp server and cdk mcp server locally using npx
npx kubernetes-mcp-server@latest &
PID1=$!
npx cdk-mcp-server@latest &
PID2=$!
trap "kill $PID1 $PID2" EXIT
wait
```

### `.github/workflows/ci.yml`

```yaml
name: CI
on:
  push:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: |
          docker build -t ${{ github.repository }}:latest ./app
      - name: Save image as artifact
        uses: actions/upload-artifact@v4
        with:
          name: image
          path: |
            ./app
```

### `LICENSE`

```text
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## Next steps (suggested)

* Replace the example app with your real microservice and update the Dockerfile.
* Add your k3s cluster provisioning scripts (cloud-init, Terraform, or user-data for EC2).
* Harden MCP servers (authentication, TLS) before exposing publicly.
* Add real CI/CD (push to ECR/GCR and deploy using kubectl or a GitOps tool).

---

If you want, I can also:

* Generate this as a zip file for download, or
* Push it to a GitHub repo if you provide a repo name and allow me to create it for you.
