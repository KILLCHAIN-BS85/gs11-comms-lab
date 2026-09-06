# Module 2 — Endpoint Provisioning

Automate device onboarding, certificate issuance, VPN tunnel setup, and baseline hardening.
This replicates the GS-11 task of provisioning and managing remote comms endpoints.

## Overview

```
  Provisioning Controller (Ansible)
          │
          ├──▶ Issue device cert  (Smallstep CA)
          ├──▶ Configure WireGuard tunnel
          ├──▶ Apply hardening baseline
          ├──▶ Install monitoring agent (osquery / Wazuh)
          └──▶ Register in inventory (Fleet / CMDB)
```

## Directory Structure

```
02-endpoint-provisioning/
├── inventory/
│   └── lab.ini                  # Ansible host inventory
├── playbooks/
│   ├── site.yml                 # Master playbook
│   ├── 01-cert-provisioning.yml # Issue device certificates
│   ├── 02-wireguard-setup.yml   # Configure WireGuard tunnels
│   ├── 03-hardening.yml         # CIS-inspired baseline hardening
│   └── 04-monitoring-agent.yml  # Install osquery / Wazuh agent
├── roles/
│   ├── pki/                     # Smallstep CA interaction
│   ├── wireguard/               # WireGuard role
│   └── hardening/               # Hardening role
├── templates/
│   ├── wg0.conf.j2              # WireGuard interface template
│   └── device-policy.json.j2   # Device policy template
└── scripts/
    ├── ca_init.sh               # Bootstrap Smallstep CA
    └── enroll_device.sh         # One-shot device enrollment
```

## Quick Start

```bash
# 1. Bootstrap the internal PKI
bash scripts/ca_init.sh

# 2. Run the full provisioning playbook
ansible-playbook -i inventory/lab.ini playbooks/site.yml

# 3. Verify device certificate
step certificate inspect /etc/ssl/device.crt

# 4. Verify WireGuard tunnel
wg show wg0
ping -c 4 10.99.0.1
```

## GS-11 Skills Practiced

- Provisioning device identity (certificates, IMEI-equivalent)
- Enforcing security profiles (hardening, firewall rules)
- Managing VPN tunnels as secure comms channels
- Tracking device compliance and configuration state
