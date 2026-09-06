# Module 1 Lab Notes — Cellular Core

## What This Replicates

A GS-11 analyst working with cellular routers regularly:
- Configures APNs, QoS profiles, and subscriber records
- Troubleshoots attachment failures (authentication, session setup)
- Monitors UE registration states and data plane forwarding
- Tests failover between APNs or network slices

This lab lets you practice all of these tasks in software.

## Step-by-Step Walkthrough

### 1. Deploy the lab
```bash
bash scripts/deploy.sh
```

### 2. Open the Open5GS WebUI
- Browse to `http://localhost:9999`
- Login: `admin` / `1423`
- Navigate to **Subscribers** to see registered UEs

### 3. Watch the UE attach in real time
```bash
# Tail AMF logs to watch 5G-AKA authentication
docker logs -f $(docker ps --filter name=amf --format '{{.Names}}')

# Tail SMF logs to watch PDU session creation
docker logs -f $(docker ps --filter name=smf --format '{{.Names}}')
```

### 4. Test traffic through the cellular interface
```bash
UE=$(docker ps --filter name=ue1 --format '{{.Names}}')

# HTTP via cellular (APN: internet)
docker exec $UE curl --interface uesimtun0 -s https://ifconfig.me
```

### 5. Test emergency APN failover
```bash
# Edit ue.yaml to add the emergency session, then restart UE container
# Verify uesimtun1 is created with 10.46.x.x address
```

## Common Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| UE stuck at "Registered, idle" | AMF/gNB N2 link issue | Check NGAP port 38412 |
| No IP on uesimtun0 | SMF/UPF PFCP issue | Check UPF logs |
| PDU session fails | Subscriber not registered | Re-run register_ue.sh |
| Cannot ping internet | UPF NAT not configured | Check ogstun iptables rules |

## Test Report Template

```
Test: UE Attachment and Data Plane Verification
Date: ___________
Lab Version: ___________

Pass/Fail Checklist:
[ ] UE registered in subscriber DB
[ ] gNB connected to AMF (NGAP established)
[ ] UE successfully authenticated (5G-AKA)
[ ] PDU session established (uesimtun0 assigned IP)
[ ] Ping 8.8.8.8 via uesimtun0: RTT = ___ ms
[ ] Emergency APN test: uesimtun1 assigned IP
[ ] QoS enforcement verified in SMF logs

Notes:
```
