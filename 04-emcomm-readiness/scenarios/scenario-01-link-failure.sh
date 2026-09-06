#!/usr/bin/env bash
# Scenario 01 — Link Failure
# Simulates a network link going down (cable cut / interface failure)
# GS-11: Emergency communications link failure response
set -euo pipefail

SCENARIO="01-link-failure"
START_TIME=$(date +%s)
LOG_FILE="../reports/scenario-${SCENARIO}-$(date +%Y%m%d-%H%M%S).log"

mkdir -p ../reports

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

log "=== SCENARIO: Link Failure ==="
log "Starting exercise at $(date)"
log "Objective: Detect and recover from simulated link failure"
log "Target: gs11-ospf-r1 eth1 (R1 ↔ R2 link)"

# ─── Inject failure ───────────────────────────────────────────────
log "[INJECT] Bringing down R1 eth1..."
R1=$(docker ps --filter "name=gs11-ospf-r1" --format "{{.Names}}" | head -1)
docker exec "$R1" ip link set eth1 down
log "[INJECT] Link down at $(date +%s)"

# ─── Detection window ─────────────────────────────────────────────
log "[MONITOR] Waiting for Prometheus to detect the failure..."
DETECT_START=$(date +%s)

for i in $(seq 1 20); do
  sleep 10
  # Query Prometheus for the HostDown alert
  STATUS=$(curl -s 'http://localhost:9090/api/v1/query?query=ALERTS{alertname="NetworkInterfaceDown",alertstate="firing"}' \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print('FIRING' if d['data']['result'] else 'PENDING')" 2>/dev/null || echo "PENDING")
  log "  [t+${i}0s] Alert status: $STATUS"
  if [[ "$STATUS" == "FIRING" ]]; then
    DETECT_TIME=$(( $(date +%s) - DETECT_START ))
    log "[DETECTED] Alert fired after ${DETECT_TIME}s"
    break
  fi
done

# ─── Recovery ─────────────────────────────────────────────────────
log "[RECOVER] Bringing link back up..."
RECOVER_START=$(date +%s)
docker exec "$R1" ip link set eth1 up

# Wait for OSPF to reconverge
for i in $(seq 1 12); do
  sleep 10
  OSPF_OK=$(docker exec "$R1" vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -c "Full" || echo "0")
  log "  [t+${i}0s] OSPF Full adjacencies: $OSPF_OK"
  if [[ "$OSPF_OK" -ge 1 ]]; then
    RECOVER_TIME=$(( $(date +%s) - RECOVER_START ))
    log "[RECOVERED] OSPF reconverged after ${RECOVER_TIME}s"
    break
  fi
done

END_TIME=$(date +%s)
TOTAL_DURATION=$(( END_TIME - START_TIME ))

log ""
log "=== SCENARIO COMPLETE ==="
log "Total duration: ${TOTAL_DURATION}s"
log "Detection time: ${DETECT_TIME:-unknown}s"
log "Recovery time:  ${RECOVER_TIME:-unknown}s"
log "Log saved to: $LOG_FILE"
log "Run generate_report.py to create the formal report."
