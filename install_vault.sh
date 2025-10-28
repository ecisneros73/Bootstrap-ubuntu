#!/usr/bin/env bash
# Install HashiCorp Vault on Ubuntu
# Works on Ubuntu 20.04 / 22.04 / 24.04
# Run with: sudo bash install-vault.sh

set -e

echo "----------------------------------------"
echo "🔧 Updating system packages..."
echo "----------------------------------------"
apt update -y
apt install -y curl gpg lsb-release apt-transport-https software-properties-common

echo "----------------------------------------"
echo "📦 Adding HashiCorp GPG key and repo..."
echo "----------------------------------------"
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add the official repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

echo "----------------------------------------"
echo "🚀 Installing Vault..."
echo "----------------------------------------"
apt update -y
apt install -y vault

echo "----------------------------------------"
echo "🔍 Verifying Vault installation..."
echo "----------------------------------------"
vault version

echo "----------------------------------------"
echo "✅ Vault installation complete!"
echo "----------------------------------------"
echo "Next steps:"
echo "  1️⃣ Run 'vault server -dev' to start Vault in dev mode."
echo "  2️⃣ Export VAULT_ADDR=http://127.0.0.1:8200"
echo "  3️⃣ Use 'vault status' to verify it's running."
