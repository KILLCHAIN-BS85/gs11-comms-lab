# Module 4 — Emergency Communications Readiness Testing

Simulate emergency scenario exercises, measure failover/convergence times, and generate readiness dashboards.
This replicates the GS-11 task of testing and tracking the readiness of emergency communications equipment.

## Overview

```
  Scenario Script
       │
       ├──▶ Inject failure (link down, service kill, power-off VM)
       ├──▶ Measure: time-to-detect, time-to-alert, time-to-recover
       ├──▶ Prometheus collects metrics during exercise
       ├──▶ Grafana dashboard shows live readiness status
       └──▶ Post-exercise report generated automatically
```

## Files

```
04-emcomm-readiness/
├── docker-compose.yml          # Prometheus + Grafana + Alertmanager
├── prometheus/
│   ├── prometheus.yml          # Scrape config
│   └── alerts/
│       ├── link-down.yml       # Link failure alerts
│       └── service-down.yml    # Service availability alerts
├── grafana/
│   └── dashboards/
│       └── readiness.json      # EMCOMM readiness dashboard
├── scenarios/
│   ├── scenario-01-link-failure.sh   # Inject link failure
│   ├── scenario-02-service-kill.sh   # Kill a core service
│   ├── scenario-03-full-site-down.sh # Take down entire "site"
│   └── scenario-04-recovery.sh      # Execute recovery procedure
├── scripts/
│   ├── measure_mttr.sh         # Measure MTTR from Prometheus data
│   └── generate_report.py      # Generate post-exercise PDF report
└── docs/
    ├── exercise-runbook.md     # ARRL-inspired exercise template
    └── test-report-template.md
```

## Quick Start

```bash
# 1. Start monitoring stack
docker compose up -d

# 2. Access dashboards
# Prometheus: http://localhost:9090
# Grafana:    http://localhost:3000 (admin/admin)

# 3. Run a scenario
bash scenarios/scenario-01-link-failure.sh

# 4. Observe recovery in Grafana dashboard
# 5. Generate post-exercise report
python3 scripts/generate_report.py --scenario 01 --output reports/
```

## ARRL-Inspired Exercise Framework

Adapted from the ARRL Simulated Emergency Test (SET) methodology:

1. **Define scenario** — what failure, what scope, what objectives
2. **Activate** — execute the scenario script
3. **Measure** — TTD (time-to-detect), TTA (time-to-alert), TTR (time-to-recover)
4. **Document** — record all actions, timestamps, and observations
5. **Post-exercise critique** — what worked, what failed, improvements

## Readiness Metrics

| Metric | Target | Description |
|--------|--------|-------------|
| MTTD | < 2 min | Mean Time to Detect |
| MTTA | < 5 min | Mean Time to Alert |
| MTTR | < 15 min | Mean Time to Recover |
| Uptime | > 99.5% | System availability |
| Alert Accuracy | > 95% | No false positives |
