# EMCOMM Exercise Runbook
*Adapted from ARRL Simulated Emergency Test (SET) methodology*

## Purpose

This runbook guides operators through a structured emergency communications
readiness exercise. The goal is to measure detection and recovery times,
identify gaps, and produce actionable improvements — exactly the work
performed by a GS-11 Telecom Systems Analyst.

## Pre-Exercise Checklist

- [ ] Monitoring stack is running (`docker compose up -d` in `04-emcomm-readiness/`)
- [ ] Prometheus is scraping all targets: http://localhost:9090/targets
- [ ] Grafana dashboard is accessible: http://localhost:3000
- [ ] All containerlab topologies are deployed and healthy
- [ ] Scenario scripts have execute permissions (`chmod +x scenarios/*.sh`)
- [ ] Log directory exists (`mkdir -p reports`)
- [ ] Exercise objectives and scope are documented below

## Exercise Definition

**Exercise Name:** _________________________________

**Date/Time:** _________________________________

**Scenario:** (circle one)
- 01 — Link Failure (network cable cut)
- 02 — Core Service Failure (AMF down)
- 03 — Full Site Down
- 04 — Recovery Procedure Drill

**Objectives:**
1. Detect the injected failure within **2 minutes**
2. Alert appropriate team within **5 minutes**
3. Restore service within **15 minutes**
4. Document findings and corrective actions

**Scope:**
- Systems involved: _________________________________
- Out of scope: _________________________________

---

## Execution Phases

### Phase 1 — INJECT (T+0:00)
```bash
bash scenarios/scenario-NN-description.sh
```
- Record exact time of injection: _____________
- Systems affected: _____________

### Phase 2 — DETECT (Target: T+0:00 to T+2:00)
- Monitor Prometheus alerts: http://localhost:9090/alerts
- Monitor Grafana dashboard: http://localhost:3000
- Record time alert fired: _____________
- **MTTD = Alert Time − Inject Time:** _____________

### Phase 3 — RESPOND (Target: T+2:00 to T+5:00)
- Who responded: _____________
- Actions taken: _____________
- Record time response initiated: _____________

### Phase 4 — RECOVER (Target: T+5:00 to T+15:00)
```bash
bash scenarios/scenario-04-recovery.sh
```
- Record time service restored: _____________
- **MTTR = Restore Time − Inject Time:** _____________

### Phase 5 — POST-EXERCISE CRITIQUE
```bash
python3 scripts/generate_report.py --scenario NN --output reports/
```

---

## Scoring

| Metric | Target | Actual | Pass/Fail |
|--------|--------|--------|-----------|
| MTTD | < 2 min | | |
| MTTA | < 5 min | | |
| MTTR | < 15 min | | |
| False alerts | 0 | | |

## Lessons Learned

**What worked well:**

**What failed:**

**Improvements for next exercise:**

---
*GS-11 EMCOMM Lab — Runbook Template*
