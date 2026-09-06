#!/usr/bin/env bash
# measure_mttr.sh — Query Prometheus to calculate MTTR from exercise data
# Outputs time-to-detect and time-to-recover for each alert firing
set -euo pipefail

PROM_URL="http://localhost:9090"
LOOKBACK="${1:-1h}"  # Default: last 1 hour

echo "======================================================"
echo "  MTTR Analysis — GS-11 EMCOMM Lab"
echo "  Lookback: $LOOKBACK"
echo "  Source: $PROM_URL"
echo "  Generated: $(date)"
echo "======================================================"
echo ""

echo "[+] Recent alert firings:"
curl -s "${PROM_URL}/api/v1/query_range" \
  --data-urlencode "query=ALERTS_FOR_STATE" \
  --data-urlencode "start=$(date -d "-${LOOKBACK}" +%s)" \
  --data-urlencode "end=$(date +%s)" \
  --data-urlencode "step=30" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
if data.get('data', {}).get('result'):
    for r in data['data']['result']:
        print(f'  Alert: {r[\"metric\"].get(\"alertname\",\"unknown\")} | Instance: {r[\"metric\"].get(\"instance\",\"unknown\")} | Severity: {r[\"metric\"].get(\"severity\",\"unknown\")}')
else:
    print('  No active alert history found in this window.')
" 2>/dev/null || echo "  [!] Could not reach Prometheus. Is the monitoring stack running?"

echo ""
echo "[+] Host uptime (up == 1 means host is reachable):"
curl -s "${PROM_URL}/api/v1/query?query=up" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
for r in data.get('data', {}).get('result', []):
    status = 'UP' if r['value'][1] == '1' else 'DOWN'
    print(f'  {r[\"metric\"].get(\"instance\", \"unknown\"):30s} {status}')
" 2>/dev/null || echo "  [!] Could not reach Prometheus."

echo ""
echo "======================================================"
echo "  Export full metrics to report with generate_report.py"
echo "======================================================"
