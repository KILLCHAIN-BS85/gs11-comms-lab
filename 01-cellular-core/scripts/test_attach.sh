#!/usr/bin/env bash
# test_attach.sh — Verify UE successfully attaches and receives an IP
# This is the GS-11 equivalent of "verify cellular router connectivity"
set -euo pipefail

UE_CONTAINER=$(docker ps --filter "name=ue1" --format "{{.Names}}" | head -1)

if [[ -z "$UE_CONTAINER" ]]; then
  echo "[!] UE container not found. Is the lab deployed?"
  exit 1
fi

echo "[+] Checking UE PDU session status..."
docker exec "$UE_CONTAINER" /UERANSIM/build/nr-cli imsi-001010000000001 -e 'ps-list'

echo ""
echo "[+] Checking assigned TUN interface (uesimtun0)..."
docker exec "$UE_CONTAINER" ip addr show uesimtun0 2>/dev/null || echo "[!] TUN interface not up yet — wait 10s and retry."

echo ""
echo "[+] Pinging 8.8.8.8 via cellular interface..."
docker exec "$UE_CONTAINER" ping -I uesimtun0 -c 4 8.8.8.8 && echo "[+] PASS: UE attached and passing traffic" || echo "[!] FAIL: No traffic through cellular interface"
