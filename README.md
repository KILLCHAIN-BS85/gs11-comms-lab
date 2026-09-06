# GS-11 Communications Systems Analyst — Lab Simulation

> Replicating the technical scope of a GS-11 Telecommunications Systems Analyst role through an open-source, VM/container-based home lab.

## Lab Modules

| # | Module | Core Tools | Status |
|---|--------|-----------|--------|
| 1 | [Cellular Core & Router Simulation](./01-cellular-core/) | Open5GS, UERANSIM, Containerlab | 🔧 In Progress |
| 2 | [Endpoint Provisioning](./02-endpoint-provisioning/) | Ansible, WireGuard, Smallstep CA | 🔧 In Progress |
| 3 | [Wired & Wireless Networks](./03-network-lab/) | GNS3, FRR, pfSense, VLANs | 🔧 In Progress |
| 4 | [EMCOMM Readiness Testing](./04-emcomm-readiness/) | Prometheus, Grafana, Python scripts | 🔧 In Progress |

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     GS-11 Lab Environment                        │
│                                                                   │
│  ┌───────────────┐    ┌─────────────────┐    ┌───────────────┐  │
│  │  Cellular Core │    │  Network Fabric  │    │  EMCOMM Tests │  │
│  │  Open5GS/     │───▶│  GNS3/FRR/       │───▶│  Prometheus/  │  │
│  │  UERANSIM     │    │  VLANs/pfSense   │    │  Grafana      │  │
│  └───────────────┘    └─────────────────┘    └───────────────┘  │
│           │                    │                      │           │
│  ┌────────▼────────────────────▼──────────────────────▼────────┐ │
│  │            Endpoint Provisioning Layer                       │ │
│  │         Ansible · WireGuard · Smallstep CA · Fleet           │ │
│  └──────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Host Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | 8 cores | 12+ cores |
| RAM | 16 GB | 32 GB |
| Storage | 100 GB SSD | 250 GB NVMe |
| Hypervisor | VirtualBox 7 | Hyper-V / VMware |
| OS | Ubuntu 22.04 LTS | Ubuntu 22.04 or Debian 12 |

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/KILLCHAIN-BS85/gs11-comms-lab.git
cd gs11-comms-lab

# 2. Install Docker + Containerlab (required for Module 1)
curl -sL https://get.docker.com | bash
bash -c "$(curl -sL https://get.containerlab.dev)"

# 3. Start with the cellular core topology
cd 01-cellular-core
containerlab deploy -t topology.yml

# 4. Run endpoint provisioning playbooks
cd ../02-endpoint-provisioning
ansible-playbook -i inventory/lab.ini playbooks/site.yml
```

## Learning Objectives

- Configure and troubleshoot 4G/5G core network elements (AMF, SMF, UPF, gNB, UE)
- Provision endpoints with certificates, VPN tunnels, and hardened baselines
- Design multi-VLAN wired/wireless topologies with OSPF, BGP, NAT, and ACLs
- Simulate emergency communications failover scenarios and measure MTTR
- Produce structured test reports, runbooks, and readiness dashboards

## Certifications This Lab Supports

- CompTIA Security+
- CompTIA Network+
- AWS/Azure Cloud Security
- ARRL EMCOMM credentials

## References

- [Open5GS Documentation](https://open5gs.org/open5gs/docs/)
- [UERANSIM GitHub](https://github.com/aligungr/UERANSIM)
- [Containerlab Documentation](https://containerlab.dev/)
- [GNS3 Network Simulator](https://www.gns3.com/)
- [ARRL Simulated Emergency Test](https://www.arrl.org/simulated-emergency-test)
