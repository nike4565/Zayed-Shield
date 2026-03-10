#!/data/data/com.termux/files/usr/bin/bash

echo "╔═══════════════════════════════════════╗"
echo "║   Zayed Shield - Installation        ║"
echo "║   درع زايد - التثبيت                 ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# Update system
echo "[*] Updating system..."
pkg update -y && pkg upgrade -y

# Install packages
echo "[*] Installing required packages..."
pkg install -y root-repo wget curl git nmap netcat-openbsd \
    iptables dnsutils tcpdump python openssl tor proxychains-ng

# Install Python packages
echo "[*] Installing Python packages..."
pip install --upgrade pip
pip install scapy requests beautifulsoup4 colorama pycryptodome

# Create directories
echo "[*] Creating directories..."
mkdir -p ~/zayed-shield/{logs,data,quarantine,modules}
mkdir -p ~/zayed-shield/logs/{network,apk,dns,firewall,system}

# Make executable
chmod +x zayed-shield.sh

echo ""
echo "✅ Installation complete!"
echo ""
echo "Run: ./zayed-shield.sh"
echo ""
