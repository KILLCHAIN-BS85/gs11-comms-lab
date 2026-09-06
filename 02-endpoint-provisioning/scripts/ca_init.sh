#!/usr/bin/env bash
# ca_init.sh — Bootstrap Smallstep internal CA
# Provides PKI for device certificate issuance
set -euo pipefail

CA_NAME="GS11-Lab-CA"
CA_DNS="pki-ca.lab.local"
CA_ADDR=":9000"

echo "[+] Installing step-ca..."
curl -fsSL https://dl.smallstep.com/gh-release/certificates/docs-ca-install/v0.25.0/step-ca_linux_0.25.0_amd64.tar.gz \
  | tar xz -C /usr/local/bin --strip-components=2 step-ca_0.25.0/bin/step-ca

echo "[+] Installing step CLI..."
curl -fsSL https://dl.smallstep.com/gh-release/cli/docs-cli-install/v0.25.0/step_linux_0.25.0_amd64.tar.gz \
  | tar xz -C /usr/local/bin --strip-components=2 step_0.25.0/bin/step

echo "[+] Initializing CA..."
step ca init \
  --name "$CA_NAME" \
  --dns "$CA_DNS" \
  --address "$CA_ADDR" \
  --provisioner admin@lab.local \
  --with-ca-url "https://${CA_DNS}${CA_ADDR}"

echo "[+] Saving CA fingerprint for Ansible..."
step certificate fingerprint $(step path)/certs/root_ca.crt > "$(dirname "$0")/../files/ca_fingerprint.txt"

echo "[+] Starting CA server..."
step-ca $(step path)/config/ca.json &
disown

echo "[+] CA is running at https://${CA_DNS}${CA_ADDR}"
echo "    Fingerprint saved to files/ca_fingerprint.txt"
