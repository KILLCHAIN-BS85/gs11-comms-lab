#!/usr/bin/env bash
# Scenario 02 — Core Service Failure
# Simulates the AMF (5G core) going down and testing detection + recovery
set -euo pipefail

SCENARIO="02-service-kill"
LOG_FILE="../reports/scenario-${SCENARIO}-$(date +%Y%m%d-%H%M%S).log"
mkdir -p ../reports

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

log "=== SCENARIO: Core Service Failure ==="
log "Target: Open5GS AMF container"
log "Objective: Detect AMF failure; document UE impact; restore service"

# ─── Inject failure ───────────────────────────────────────────────
AMF_CONTAINER=$(docker ps --filter "name=amf" --format "{{.Names}}" | head -1)
log "[INJECT] Stopping AMF: $AMF_CONTAINER"
docker stop "$AMF_CONTAINER"
INJECT_TIME=$(date +%s)

# ─── Measure impact ───────────────────────────────────────────────
log "[MONITOR] Checking UE registration state..."
UE=$(docker ps --filter "name=ue1" --format "{{.Names}}" | head -1)
sleep 10
docker exec "$UE" /UERANSIM/build/nr-cli imsi-001010000000001 -e 'ps-list' 2>&1 | tee -a "$LOG_FILE" || log "[!] UE cannot reach AMF (expected)"

# ─── Recovery ─────────────────────────────────────────────────────
log "[RECOVER] Restarting AMF..."
docker start "$AMF_CONTAINER"
RECOVER_START=$(date +%s)

for i in $(seq 1 12); do
  sleep 10
  AMF_UP=$(docker inspect "$AMF_CONTAINER" --format '{{.State.Running}}' 2>/dev/null || echo false)
  log "  [t+${i}0s] AMF running: $AMF_UP"
  if [[ "$AMF_UP" == "true" ]]; then
    RECOVER_TIME=$(( $(date +%s) - RECOVER_START ))
    log "[RECOVERED] AMF back online after ${RECOVER_TIME}s"
    break
  fi
done

log "[VERIFY] Waiting for UE re-registration (30s)..."
sleep 30
docker exec "$UE" /UERANSIM/build/nr-cli imsi-001010000000001 -e 'ps-list' 2>&1 | tee -a "$LOG_FILE" || log "[!] UE re-registration incomplete"

log "=== SCENARIO COMPLETE ==="
log "Log: $LOG_FILE"
