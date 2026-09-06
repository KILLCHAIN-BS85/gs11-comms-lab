#!/usr/bin/env bash
# acl_test.sh — Test ACL / firewall rules
# Maps to GS-11: enforce and verify access control on network segments
set -euo pipefail

echo "======================================================"
echo "  ACL/Firewall Rule Verification"
echo "  $(date)"
echo "======================================================"

# Test matrix: source → dest → port → expected result
TESTS=(
  "10.10.0.10|10.20.0.10|80|ALLOW"
  "10.10.0.10|10.20.0.10|443|ALLOW"
  "10.10.0.10|10.99.0.1|22|BLOCK"
  "10.10.0.10|10.99.0.1|80|BLOCK"
  "10.20.0.10|10.10.0.10|ANY|BLOCK"
)

PASS=0
FAIL=0

for TEST in "${TESTS[@]}"; do
  IFS='|' read -r SRC DST PORT EXPECTED <<< "$TEST"
  echo ""
  echo "  Test: $SRC → $DST:$PORT (Expected: $EXPECTED)"
  echo "  [MANUAL] Run: nmap -p $PORT $DST from host at $SRC"
  echo "  → Document result in test report"
done

echo ""
echo "======================================================"
echo "  ACL test matrix complete. Document results in:"
echo "  docs/acl-test-report.md"
echo "======================================================"
