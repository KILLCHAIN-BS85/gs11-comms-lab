#!/usr/bin/env bash
# vlan_test.sh — Test VLAN segmentation and inter-VLAN routing
set -euo pipefail

echo "======================================================"
echo "  VLAN Segmentation Test — GS-11 Network Lab"
echo "  $(date)"
echo "======================================================"

echo ""
echo "[+] Test 1: Intra-VLAN connectivity (same VLAN hosts)"
# Replace with actual container names once deployed
# docker exec vlan10-host1 ping -c 2 10.10.0.2
echo "  [MANUAL] Verify hosts in VLAN 10 can ping each other"
echo "  Expected: 10.10.0.x ↔ 10.10.0.x"

echo ""
echo "[+] Test 2: Inter-VLAN routing (via firewall)"
echo "  [MANUAL] Verify VLAN 10 can reach VLAN 20 via firewall rules"
echo "  Expected: 10.10.0.x → 10.20.0.x (allowed ports only)"

echo ""
echo "[+] Test 3: VLAN isolation (blocked traffic)"
echo "  [MANUAL] Verify VLAN 10 CANNOT reach VLAN 99 (management)"
echo "  Expected: 10.10.0.x → 10.99.0.x = BLOCKED"

echo ""
echo "[+] Test 4: Internet access via NAT"
echo "  [MANUAL] Verify VLAN 10 hosts can reach 8.8.8.8 via NAT"

echo ""
echo "Document results in docs/vlan-test-report.md"
