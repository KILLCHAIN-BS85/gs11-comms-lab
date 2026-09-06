#!/usr/bin/env bash
# register_ue.sh — Register test UE subscribers in Open5GS MongoDB
# Replicates provisioning a SIM/subscriber profile (GS-11 task)
set -euo pipefail

MONGO_CONTAINER=$(docker ps --filter "name=mongo" --format "{{.Names}}" | head -1)

if [[ -z "$MONGO_CONTAINER" ]]; then
  echo "[!] MongoDB container not found. Is the lab deployed?"
  exit 1
fi

echo "[+] Registering UE: IMSI 001010000000001"
docker exec "$MONGO_CONTAINER" mongosh open5gs --eval '
  db.subscribers.insertOne({
    imsi: "001010000000001",
    msisdn: [],
    imeisv: "4370816125816151",
    security: {
      k: "465B5CE8B199B49FAA5F0A2EE238A6BC",
      amf: "8000",
      op: null,
      opc: "E8ED289DEBA952E4283B54E88E6183CA"
    },
    ambr: {
      downlink: { value: 1, unit: 3 },
      uplink:   { value: 1, unit: 3 }
    },
    slice: [{
      sst: 1,
      default_indicator: true,
      session: [{
        name: "internet",
        type: 3,
        qos: { index: 9, arp: { priority_level: 8, pre_emption_capability: 1, pre_emption_vulnerability: 2 } },
        ambr: {
          downlink: { value: 1, unit: 3 },
          uplink:   { value: 1, unit: 3 }
        },
        pcc_rule: []
      }]
    }],
    access_restriction_data: 32,
    subscriber_status: 0,
    operator_determined_barring: 0,
    network_access_mode: 0,
    __v: 0
  });
  print("UE registered.");
'

echo "[+] Subscriber registration complete."
