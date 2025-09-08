#!/usr/bin/env bash
set -e
# Start example MCP servers using npx in background (requires Node & npx)
npx kubernetes-mcp-server@latest & PID1=$!
npx cdk-mcp-server@latest & PID2=$!
echo "Started MCP servers (pids: $PID1, $PID2). Ctrl-C to stop."
trap "kill $PID1 $PID2" EXIT
wait
