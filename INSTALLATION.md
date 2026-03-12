<div align="center">

<img src="https://img.shields.io/badge/🛡️_ZAYED_SHIELD-INSTALLATION_GUIDE-gold?style=for-the-badge&labelColor=0a0a0a" />

[![Node.js](https://img.shields.io/badge/Node.js-≥20.0-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![Python](https://img.shields.io/badge/Python-≥3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Docker](https://img.shields.io/badge/Docker-Supported-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://docker.com)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Helm_Chart-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![Platform](https://img.shields.io/badge/Platform-Linux_|_macOS-009A44?style=for-the-badge&logo=linux&logoColor=white)](https://github.com/nike4565/Zayed-Shield)

</div>

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start-30-seconds)
- [Standard Installation](#-standard-installation)
- [Docker Installation](#-docker-installation)
- [Kubernetes / Helm](#-kubernetes--helm)
- [Verify Installation](#-verify-installation)
- [First Run Setup](#-first-run-setup)
- [Troubleshooting](#-troubleshooting)

---

## ✅ Prerequisites

### System Requirements

| Component | Minimum | Recommended |
|:---------:|:-------:|:-----------:|
| **OS** | Ubuntu 22.04 / Debian 11 | Ubuntu 24.04 LTS |
| **CPU** | 2 cores | 4+ cores |
| **RAM** | 4 GB | 8+ GB |
| **Storage** | 20 GB | 100+ GB (for archive) |
| **Network** | 100 Mbps | 1 Gbps |

### Software Requirements

```bash
# Check versions before proceeding
node   --version    # Must be ≥ 20.0.0
python --version    # Must be ≥ 3.11.0
git    --version    # Must be ≥ 2.40.0
docker --version    # Must be ≥ 24.0.0  (optional)
```

Install missing dependencies:

```bash
# Ubuntu / Debian
sudo apt update && sudo apt install -y \
  git curl wget build-essential \
  python3.11 python3-pip python3-venv \
  openssl libssl-dev gnupg2

# Install Node.js 20 (LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

### GPG Setup (Required for Security Team)

```bash
# Import Zayed Shield signing key
gpg --recv-keys 8429D4C1ECAC3080BCB84AA0982159B70BA77EFD

# Verify
gpg --fingerprint 8429D4C1ECAC3080BCB84AA0982159B70BA77EFD
```

---

## ⚡ Quick Start (30 seconds)

```bash
# Clone
git clone https://github.com/nike4565/Zayed-Shield.git
cd Zayed-Shield

# Install all dependencies
npm install && pip3 install -r requirements.txt

# Copy environment template
cp .env.example .env

# Start in development mode
npm run dev
```

Open **http://localhost:3000** — the dashboard should appear. 🛡️

---

## 🔧 Standard Installation

### Step 1 — Clone & Verify

```bash
# Clone the repository
git clone https://github.com/nike4565/Zayed-Shield.git
cd Zayed-Shield

# Verify GPG signature of latest release tag
git tag -v v3.0.0
# Expected: Good signature from asrar-mared (8429D4C1...)
```

### Step 2 — Install Dependencies

```bash
# Node.js dependencies (firewall, gateway, monitor)
npm ci --production

# Python dependencies (AI engine, forensics)
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Verify no known vulnerabilities
npm audit
pip-audit
```

### Step 3 — Environment Configuration

```bash
# Copy the template
cp .env.example .env

# Edit with your settings
nano .env
```

Minimum required variables:

```env
# Core
NODE_ENV=production
PORT=3000

# Key Gateway
KEY_ROTATION_INTERVAL=300        # seconds (default: 5 min)
KEY_ENTROPY_BITS=256

# AI Engine
AI_MODEL_PATH=./data/ml-models/zs-detector-v3.bin
AI_INFERENCE_TIMEOUT_MS=50

# Firewall
FIREWALL_MODE=active             # active | monitor | passive
FIREWALL_LOG_BLOCKED=true

# Archive
ARCHIVE_PATH=./archive
ARCHIVE_ENCRYPTION=true
```

### Step 4 — Initialize Database & Archive

```bash
# Run first-time setup
npm run setup

# Expected output:
# ✅ Archive directory initialized
# ✅ Threat intelligence DB loaded (XXXX signatures)
# ✅ AI model loaded (v3.0.0)
# ✅ Firewall rules compiled
# ✅ Key rotation scheduler started
# ✅ System ready
```

### Step 5 — Start Services

```bash
# Start all services
npm run start

# Or start individually:
npm run start:firewall    # Firewall module
npm run start:ai          # AI engine
npm run start:gateway     # Key gateway
npm run start:forensics   # Forensics module
npm run start:monitor     # Dashboard (http://localhost:3000)
```

### Step 6 — Run as System Service (Production)

```bash
# Install systemd service
sudo cp deploy/zayed-shield.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable zayed-shield
sudo systemctl start zayed-shield

# Check status
sudo systemctl status zayed-shield
```

---

## 🐳 Docker Installation

### Single Container

```bash
# Pull image
docker pull ghcr.io/nike4565/zayed-shield:latest

# Run with minimum config
docker run -d \
  --name zayed-shield \
  -p 3000:3000 \
  -v $(pwd)/archive:/app/archive \
  -v $(pwd)/.env:/app/.env:ro \
  --restart unless-stopped \
  ghcr.io/nike4565/zayed-shield:latest
```

### Docker Compose (All Services)

```bash
# Clone
git clone https://github.com/nike4565/Zayed-Shield.git
cd Zayed-Shield

# Configure
cp .env.example .env
nano .env

# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Services started:
# · zayed-shield-firewall    (port: internal)
# · zayed-shield-ai          (port: internal)
# · zayed-shield-gateway     (port: internal)
# · zayed-shield-forensics   (port: internal)
# · zayed-shield-monitor     (port: 3000 → dashboard)
# · zayed-shield-db          (port: internal)
```

---

## ☸️ Kubernetes / Helm

```bash
# Add Helm repository
helm repo add zayed-shield https://nike4565.github.io/Zayed-Shield/charts
helm repo update

# Install with defaults
helm install zayed-shield zayed-shield/zayed-shield \
  --namespace security \
  --create-namespace

# Install with custom values
helm install zayed-shield zayed-shield/zayed-shield \
  --namespace security \
  --create-namespace \
  --set gateway.rotationInterval=300 \
  --set firewall.mode=active \
  --set ai.modelVersion=v3 \
  --set monitor.replicas=2

# Check deployment
kubectl get pods -n security
kubectl get svc -n security
```

---

## ✔️ Verify Installation

```bash
# Run built-in health check
npm run health

# Expected output:
# ✅ [FIREWALL]  Active — 0 threats blocked
# ✅ [AI ENGINE] Model loaded — accuracy: 99.7%
# ✅ [GATEWAY]   Key valid — rotates in 284s
# ✅ [FORENSICS] Ready — 0 jobs queued
# ✅ [MONITOR]   Dashboard at http://localhost:3000
# ✅ [ARCHIVE]   856 advisories · 5 CVEs indexed

# Run security self-test
npm run test:security

# Run full test suite
npm test
```

---

## 🚀 First Run Setup

When you open the dashboard for the first time at **http://localhost:3000**:

```
1. Create admin account
   └── Use a strong password (min 16 chars)
   └── Enable MFA (TOTP recommended)

2. Configure alert destinations
   └── Email / webhook for threat alerts

3. Import threat intelligence (optional)
   └── Settings → Threat Feeds → Import

4. Set firewall rules baseline
   └── Firewall → Rules → Auto-generate from traffic

5. Run first forensic scan (optional)
   └── Forensics → New Scan → Upload file
```

---

## 🛠️ Troubleshooting

<details>
<summary><b>❌ Port 3000 already in use</b></summary>

```bash
# Find what's using port 3000
lsof -i :3000

# Kill it or change port in .env
PORT=3001 npm run start
```
</details>

<details>
<summary><b>❌ AI model fails to load</b></summary>

```bash
# Download model manually
npm run download:model

# Verify checksum
sha256sum data/ml-models/zs-detector-v3.bin
# Compare with checksums.txt
```
</details>

<details>
<summary><b>❌ Key rotation not working</b></summary>

```bash
# Check runtime directory permissions
ls -la runtime/keys/
# Must be owned by the running user

# Fix permissions
chmod 700 runtime/keys/
```
</details>

<details>
<summary><b>❌ Docker permission denied</b></summary>

```bash
sudo usermod -aG docker $USER
newgrp docker
```
</details>

<details>
<summary><b>❌ Python dependencies fail</b></summary>

```bash
# Ensure using venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt --no-cache-dir
```
</details>

---

<div align="center">

[![Open Issue](https://img.shields.io/badge/Still_stuck%3F-Open_an_Issue-EF3340?style=for-the-badge&logo=github)](https://github.com/nike4565/Zayed-Shield/issues/new)
[![Read Docs](https://img.shields.io/badge/Read-Full_Docs-009A44?style=for-the-badge&logo=readthedocs&logoColor=white)](https://github.com/nike4565/Zayed-Shield/tree/main/docs)

**🛡️ Zayed Shield Enterprise Security**

`INSTALLATION GUIDE · درع زايد · UAE © 2025`

</div>

