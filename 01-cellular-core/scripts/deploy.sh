#!/usr/bin/env bash
# deploy.sh — Deploy the GS-11 cellular core lab
set -euo pipefail

echo "[+] Checking prerequisites..."
command -v docker >/dev/null || { echo "Docker not found. Install: curl -sL https://get.docker.com | bash"; exit 1; }
command -v containerlab >/dev/null || { echo "Containerlab not found. Install: bash -c \"\$(curl -sL https://get.containerlab.dev)\""; exit 1; }

echo "[+] Deploying 5G core topology..."
containerlab deploy -t topology.yml

echo "[+] Waiting for Open5GS services to initialize (30s)..."
sleep 30

echo "[+] Registering test UE subscribers..."
bash scripts/register_ue.sh

echo "[+] Running attachment test..."
bash scripts/test_attach.sh

echo ""
echo "====================================="
echo "  Lab deployed successfully!"
echo "  Open5GS WebUI: http://localhost:9999"
echo "  Default login: admin / 1423"
echo "====================================="
