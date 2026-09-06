#!/usr/bin/env bash
# Scenario 04 — Full Recovery Procedure
# Standardized recovery runbook for all scenario types
# GS-11: Execute emergency comms restoration procedure
set -euo pipefail

LOG_FILE="../reports/recovery-$(date +%Y%m%d-%H%M%S).log"
mkdir -p ../reports

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

log "=== RECOVERY PROCEDURE INITIATED ==="
log "Operator: ${USER}"
log "Start time: $(date)"

# ─── Step 1: Check all containers ────────────────────────────────
log "[STEP 1] Checking container health..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | tee -a "$LOG_FILE"

# ─── Step 2: Restart any stopped containers ──────────────────────
log "[STEP 2] Restarting stopped containers..."
for CONTAINER in $(docker ps -a --filter status=exited --format '{{.Names}}'); do
  log "  [+] Restarting $CONTAINER"
  docker start "$CONTAINER"
  sleep 5
done

# ─── Step 3: Verify OSPF convergence ─────────────────────────────
log "[STEP 3] Verifying OSPF convergence..."
for ROUTER in r1 r2 r3; do
  CONTAINER=$(docker ps --filter "name=gs11-ospf-${ROUTER}" --format "{{.Names}}" | head -1)
  if [[ -n "$CONTAINER" ]]; then
    FULL=$(docker exec "$CONTAINER" vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -c "Full" || echo 0)
    log "  $ROUTER: $FULL Full adjacencies"
  fi
done

# ─── Step 4: Verify UE attachment ────────────────────────────────
log "[STEP 4] Verifying UE cellular attachment..."
UE=$(docker ps --filter "name=ue1" --format "{{.Names}}" | head -1)
if [[ -n "$UE" ]]; then
  docker exec "$UE" /UERANSIM/build/nr-cli imsi-001010000000001 -e 'ps-list' 2>&1 | tee -a "$LOG_FILE"
  IP=$(docker exec "$UE" ip addr show uesimtun0 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1 || echo "none")
  log "  UE IP via cellular: $IP"
fi

# ─── Step 5: Verify monitoring stack ─────────────────────────────
log "[STEP 5] Checking Prometheus/Grafana..."
curl -sf http://localhost:9090/-/healthy && log "  Prometheus: OK" || log "  [!] Prometheus: FAIL"
curl -sf http://localhost:3000/api/health && log "  Grafana: OK" || log "  [!] Grafana: FAIL"

log ""
log "=== RECOVERY COMPLETE ==="
log "Review any [!] warnings above and document in the post-exercise report."
