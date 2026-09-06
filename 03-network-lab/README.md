# Module 3 — Wired & Wireless Network Lab

Build multi-router, multi-switch topologies with VLANs, OSPF/BGP, NAT, ACLs, and Wi-Fi simulation.
This replicates the GS-11 task of designing, configuring, and troubleshooting communications networks.

## Lab Topologies

### Topology A — VLAN Segmentation + Routing
```
                    [pfSense Firewall/Router]
                    192.168.1.1 / 10.0.0.1
                         │
              ┌──────────┼──────────┐
              │          │          │
         [SW-CORE]    [SW-DMZ]  [SW-MGMT]
              │          │          │
        VLAN 10      VLAN 20    VLAN 99
     (Endpoints)    (Servers)  (Mgmt/OOB)
         /    \         │
      UE1    UE2    Web Server
   (10.10.x)      (10.20.x)
```

### Topology B — OSPF Multi-Area
```
  [R1: Area 0 ABR] ─── [R2: Area 0 ABR]
       │                      │
  [R3: Area 1]           [R4: Area 2]
       │                      │
  [Endpoints]           [Endpoints]
```

## Files

```
03-network-lab/
├── gns3/
│   └── gs11-vlan-lab.gns3      # GNS3 project file
├── containerlab/
│   └── topology-ospf.yml       # FRR OSPF multi-area topology
├── configs/
│   ├── pfsense/
│   │   ├── vlans.xml            # pfSense VLAN config export
│   │   └── firewall-rules.xml  # Firewall ruleset
│   └── frr/
│       ├── r1-frr.conf         # FRR router 1 (OSPF ABR)
│       ├── r2-frr.conf         # FRR router 2
│       └── r3-frr.conf         # FRR router 3
├── scripts/
│   ├── vlan_test.sh            # VLAN connectivity tests
│   ├── ospf_verify.sh          # OSPF adjacency verification
│   └── acl_test.sh             # ACL / firewall rule testing
└── docs/
    └── lab-notes.md
```

## Quick Start

### Option A — Containerlab (FRR OSPF)
```bash
containerlab deploy -t containerlab/topology-ospf.yml

# Verify OSPF adjacencies
bash scripts/ospf_verify.sh

# Test inter-VLAN routing
bash scripts/vlan_test.sh
```

### Option B — GNS3
```bash
# Import the .gns3 project file in GNS3 GUI
# File → Import portable project → gns3/gs11-vlan-lab.gns3
```

## Key Skills Practiced

- 802.1Q VLAN configuration and inter-VLAN routing
- OSPF multi-area design and verification (`show ip ospf neighbor`)
- BGP peering and route advertisement
- NAT/PAT for internet access simulation
- ACL and firewall rule design and testing
- Network monitoring with Wireshark / tcpdump
