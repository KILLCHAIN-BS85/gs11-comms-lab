# Module 1 — Cellular Core & Router Simulation

Simulate 4G LTE and 5G NR core networks using Open5GS + UERANSIM inside Containerlab.
This replicates the behavior of cellular routers (UEs), base stations (gNBs), and the full 5G core
without requiring real radio hardware.

## Architecture

```
┌──────────────────────────────────────────────────────┐
│                 5G Core (Open5GS)                     │
│  AMF ─── SMF ─── UPF ─── PCF ─── UDM ─── AUSF        │
│   │               │                                   │
│   │               └──▶ Internet / Data Network        │
└───┼──────────────────────────────────────────────────┘
    │  N2 / N3
┌───▼──────────────────────────────────────────────────┐
│                 RAN (UERANSIM)                         │
│   gNB (base station) ─── UE1 ─── UE2 ─── UE3         │
└──────────────────────────────────────────────────────┘
```

## Components

| Component | Role | Tool |
|-----------|------|------|
| AMF | Access & Mobility Management | Open5GS |
| SMF | Session Management | Open5GS |
| UPF | User Plane (data forwarding) | Open5GS |
| gNB | gNodeB (base station emulator) | UERANSIM |
| UE | User Equipment (cellular router) | UERANSIM |

## Files

```
01-cellular-core/
├── topology.yml          # Containerlab topology definition
├── configs/
│   ├── open5gs/
│   │   ├── amf.yaml      # AMF configuration
│   │   ├── smf.yaml      # SMF + APN/DNN definitions
│   │   └── upf.yaml      # UPF configuration
│   └── ueransim/
│       ├── gnb.yaml      # gNodeB configuration
│       └── ue.yaml       # UE / cellular router config
├── scripts/
│   ├── deploy.sh         # One-shot deploy script
│   ├── register_ue.sh    # Register UE subscribers in Open5GS DB
│   └── test_attach.sh    # Verify UE attach and IP assignment
└── docs/
    └── lab-notes.md      # Step-by-step walkthrough
```

## Quick Start

```bash
# Deploy the containerlab topology
containerlab deploy -t topology.yml

# Register test UEs in the Open5GS subscriber database
bash scripts/register_ue.sh

# Verify UE attachment and IP assignment
bash scripts/test_attach.sh

# Inspect container networking
docker ps
containerlab inspect -t topology.yml
```

## Key Concepts Practiced

- UE registration, authentication (5G-AKA), and PDU session setup
- APN/DNN configuration and QoS policy enforcement
- GTP-U tunneling between gNB and UPF
- Monitoring attach events via Open5GS WebUI (`http://localhost:9999`)
- Simulating cellular router CPE behavior (IP assignment, routing)
