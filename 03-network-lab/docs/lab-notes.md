# Module 3 Lab Notes — Network Lab

## GS-11 Relevance

A GS-11 Telecom Analyst routinely:
- Designs and documents network topologies for comms systems
- Configures routing protocols and verifies adjacencies
- Enforces and audits firewall/ACL rules
- Troubleshoots layer 2-3 connectivity issues
- Segments networks for security and operational isolation

## VLAN Design Reference

| VLAN | ID | Subnet | Purpose |
|------|----|--------|---------|
| Endpoints | 10 | 10.10.0.0/24 | User devices, cellular UEs |
| Servers/DMZ | 20 | 10.20.0.0/24 | Lab services, web servers |
| Management | 99 | 10.99.0.0/24 | OOB management, WireGuard hub |

## OSPF Area Design

| Area | ID | Routers | Type |
|------|----|---------|----- |
| Backbone | 0 | R1, R2 | Normal |
| CPE Network | 1 | R1(ABR), R2(ABR), R3 | Stub |

## Verification Commands

```bash
# OSPF
vtysh -c 'show ip ospf neighbor'
vtysh -c 'show ip ospf database'
vtysh -c 'show ip route ospf'

# VLANs (Linux bridge)
bridge vlan show
ip link show type vlan

# Packet capture (Wireshark/tcpdump)
tcpdump -i eth1 -nn ospf
tcpdump -i eth1 -nn 'vlan and host 10.10.0.10'

# Port scan for ACL verification
nmap -p 80,443,22 10.20.0.10 --source-ip 10.10.0.10
```

## Useful Wireshark Filters

```
ospf                          # OSPF traffic
vlan.id == 10                 # VLAN 10 only
ip.addr == 10.10.0.10         # Specific host
tcp.flags.syn == 1            # TCP SYN (connection attempts)
icmp                          # ICMP ping
```
