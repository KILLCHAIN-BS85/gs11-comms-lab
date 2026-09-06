#!/usr/bin/env bash
# ospf_verify.sh — Verify OSPF adjacencies in the GS-11 network lab
set -euo pipefail

ROUTERS=(r1 r2 r3)

echo "======================================================"
echo "  OSPF Adjacency Verification — GS-11 Network Lab"
echo "  $(date)"
echo "======================================================"

for ROUTER in "${ROUTERS[@]}"; do
  CONTAINER=$(docker ps --filter "name=gs11-ospf-${ROUTER}" --format "{{.Names}}" | head -1)
  if [[ -z "$CONTAINER" ]]; then
    echo "[!] $ROUTER container not found"
    continue
  fi

  echo ""
  echo "─── $ROUTER (${CONTAINER}) ───"

  echo "  OSPF Neighbors:"
  docker exec "$CONTAINER" vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -E 'Full|2-Way|Init' | while read line; do
    echo "    $line"
  done

  echo "  OSPF Routes:"
  docker exec "$CONTAINER" vtysh -c "show ip route ospf" 2>/dev/null | head -15
done

echo ""
echo "======================================================"
echo "  Connectivity Tests"
echo "======================================================"

# Cross-area ping test
echo "[+] Testing cross-area connectivity (host1 → host2)..."
HOST1=$(docker ps --filter "name=gs11-ospf-host1" --format "{{.Names}}" | head -1)
if [[ -n "$HOST1" ]]; then
  docker exec "$HOST1" ping -c 3 10.2.100.10 && echo "[PASS] Cross-area routing works" || echo "[FAIL] No cross-area connectivity"
fi
