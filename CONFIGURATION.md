<div align="center">

<img src="https://img.shields.io/badge/🛡️_ZAYED_SHIELD-CONFIGURATION_GUIDE-gold?style=for-the-badge&labelColor=0a0a0a" />

[![Config Format](https://img.shields.io/badge/Format-YAML_|_ENV-FFD700?style=for-the-badge&logo=yaml&logoColor=black)](https://github.com/nike4565/Zayed-Shield)
[![Encryption](https://img.shields.io/badge/Secrets-AES--512_Encrypted-EF3340?style=for-the-badge&logo=letsencrypt&logoColor=white)](https://github.com/nike4565/Zayed-Shield/blob/main/SECURITY.md)
[![Hot Reload](https://img.shields.io/badge/Config-Hot_Reload_✅-009A44?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://github.com/nike4565/Zayed-Shield)

</div>

---

## 📋 Table of Contents

- [Configuration Files](#-configuration-files)
- [Environment Variables](#-environment-variables)
- [Firewall Configuration](#-firewall-configuration)
- [AI Engine Configuration](#-ai-engine-configuration)
- [Gateway Configuration](#-gateway-configuration)
- [Forensics Configuration](#-forensics-configuration)
- [Monitor / Dashboard](#-monitor--dashboard-configuration)
- [Logging Configuration](#-logging-configuration)
- [Security Hardening](#-security-hardening)

---

## 📁 Configuration Files

```
config/
├── firewall.yml        # Firewall rules and policies
├── ai-model.yml        # AI engine and model settings
├── gateway.yml         # Key gateway and rotation settings
├── forensics.yml       # Forensics module settings
├── alerts.yml          # Alert routing and thresholds
├── logging.yml         # Log levels, rotation, outputs
└── compliance.yml      # NCA / UAE IA compliance settings

.env                    # Environment variables (never commit!)
.env.example            # Template (safe to commit)
```

> ⚠️ **Never commit `.env` to version control.** It is in `.gitignore` by default.

---

## 🌐 Environment Variables

Complete `.env` reference:

```env
# ══════════════════════════════════════
# CORE SETTINGS
# ══════════════════════════════════════
NODE_ENV=production                    # production | development | test
PORT=3000                              # Dashboard HTTP port
HOST=0.0.0.0                          # Bind address
LOG_LEVEL=info                         # debug | info | warn | error

# ══════════════════════════════════════
# SECURITY
# ══════════════════════════════════════
SECRET_KEY=<generate: openssl rand -hex 64>
JWT_SECRET=<generate: openssl rand -hex 64>
JWT_EXPIRY=3600                        # seconds
BCRYPT_ROUNDS=14
MFA_ENABLED=true
SESSION_TIMEOUT=1800                   # seconds

# ══════════════════════════════════════
# KEY GATEWAY
# ══════════════════════════════════════
KEY_ROTATION_INTERVAL=300              # seconds (default: 5 min)
KEY_ENTROPY_BITS=256
KEY_ALGORITHM=AES-512
KEY_STORE_PATH=./runtime/keys
KEY_BACKUP_COUNT=3                     # Keep last N expired keys
BARCODE_FORMAT=CODE128

# ══════════════════════════════════════
# AI ENGINE
# ══════════════════════════════════════
AI_MODEL_PATH=./data/ml-models/zs-detector-v3.bin
AI_INFERENCE_TIMEOUT_MS=50
AI_CONFIDENCE_THRESHOLD=0.85           # 0.0 - 1.0
AI_BATCH_SIZE=32
AI_GPU_ENABLED=false                   # Set true if CUDA available

# ══════════════════════════════════════
# FIREWALL
# ══════════════════════════════════════
FIREWALL_MODE=active                   # active | monitor | passive
FIREWALL_LOG_BLOCKED=true
FIREWALL_GEO_ENABLED=true
FIREWALL_GEO_ALLOWLIST=AE,EG,SA,US,GB # ISO country codes
FIREWALL_DDOS_THRESHOLD=10000          # requests/sec before mitigation
FIREWALL_RATE_LIMIT=100                # requests/sec per IP

# ══════════════════════════════════════
# FORENSICS
# ══════════════════════════════════════
FORENSICS_MAX_FILE_SIZE_MB=500
FORENSICS_ALLOWED_TYPES=jpg,png,pdf,zip,exe,bin
FORENSICS_OUTPUT_PATH=./archive/forensics
FORENSICS_STEG_DETECTION=true
FORENSICS_EXIF_STRIP=false

# ══════════════════════════════════════
# ARCHIVE
# ══════════════════════════════════════
ARCHIVE_PATH=./archive
ARCHIVE_ENCRYPTION=true
ARCHIVE_COMPRESSION=true
ARCHIVE_RETENTION_DAYS=0              # 0 = keep forever

# ══════════════════════════════════════
# ALERTS
# ══════════════════════════════════════
ALERT_EMAIL=nike494949@outlook.sa
ALERT_WEBHOOK_URL=                    # Optional: Slack/Teams webhook
ALERT_SEVERITY_MIN=medium             # low | medium | high | critical

# ══════════════════════════════════════
# DATABASE
# ══════════════════════════════════════
DB_TYPE=sqlite                         # sqlite | postgres | mysql
DB_PATH=./data/zayed-shield.db         # for sqlite
DB_HOST=                               # for postgres/mysql
DB_PORT=5432
DB_NAME=zayed_shield
DB_USER=
DB_PASSWORD=
```

---

## 🔥 Firewall Configuration

**`config/firewall.yml`**

```yaml
# Zayed Shield — Firewall Configuration
# درع زايد — إعدادات الجدار الناري

version: "3.0"
mode: active   # active | monitor | passive

# ── Rate Limiting
rate_limiting:
  enabled: true
  global_rps: 100000         # requests per second (total)
  per_ip_rps: 100            # requests per second (per IP)
  burst_multiplier: 3        # allow 3x burst for short periods
  lockout_duration: 3600     # seconds to block after threshold

# ── DDoS Protection
ddos:
  enabled: true
  threshold_rps: 10000       # trigger mitigation above this
  mitigation_mode: drop      # drop | challenge | rate_limit
  scrubbing_enabled: true
  syn_flood_protection: true
  udp_flood_protection: true

# ── Geo-Fencing
geo_fencing:
  enabled: true
  mode: allowlist            # allowlist | blocklist
  allowlist:
    - AE    # United Arab Emirates
    - EG    # Egypt
    - SA    # Saudi Arabia
    - US    # United States
    - GB    # United Kingdom
    - DE    # Germany
  blocklist: []              # used when mode: blocklist

# ── Deep Packet Inspection
dpi:
  enabled: true
  protocols:
    - http
    - https
    - dns
    - smtp
    - ftp
  signature_db: ./data/signatures/dpi-rules.db
  auto_update: true
  update_interval: 21600     # seconds (6 hours)

# ── SSL/TLS Inspection
tls_inspection:
  enabled: false             # requires certificate authority setup
  ca_cert: ./config/ca.crt
  ca_key: ./config/ca.key   # keep this SECRET

# ── Logging
logging:
  blocked: true
  allowed: false             # high volume — enable only for debug
  format: json
  output: ./runtime/logs/firewall.log

# ── Custom Rules (append to defaults)
custom_rules:
  - name: "Block known malicious IPs"
    action: drop
    src_ip:
      - "0.0.0.0/0"          # replace with actual blocklist
  - name: "Allow internal monitoring"
    action: allow
    src_ip:
      - "127.0.0.1/32"
      - "10.0.0.0/8"
```

---

## 🤖 AI Engine Configuration

**`config/ai-model.yml`**

```yaml
# Zayed Shield — AI Engine Configuration

version: "3.0"

model:
  path: ./data/ml-models/zs-detector-v3.bin
  version: "3.0.0"
  checksum: sha256:...        # verified on load
  type: ensemble              # ensemble | lstm | cnn | transformer

inference:
  timeout_ms: 50              # max milliseconds per inference
  confidence_threshold: 0.85  # below this → manual review
  batch_size: 32
  queue_max: 1000             # max pending inferences
  gpu_enabled: false

# ── Model Components (Ensemble)
ensemble:
  lstm:
    enabled: true
    weight: 0.4               # contribution to final score
    sequence_length: 100
  cnn:
    enabled: true
    weight: 0.4
    kernel_size: 3
  baseline_profiler:
    enabled: true
    weight: 0.2
    profile_window: 3600      # seconds of history for baseline

# ── Threat Categories
categories:
  - name: malware
    threshold: 0.90
    action: block
  - name: intrusion_attempt
    threshold: 0.85
    action: block_and_alert
  - name: data_exfiltration
    threshold: 0.80
    action: block_and_alert
  - name: anomaly
    threshold: 0.70
    action: alert
  - name: reconnaissance
    threshold: 0.60
    action: log

# ── Auto-Retrain
retrain:
  enabled: false              # enable only with Security Team approval
  trigger: manual             # manual | scheduled | drift_detected
  schedule: "0 2 * * 0"      # weekly at 2am Sunday (if scheduled)
  validation_threshold: 0.99  # new model must beat this to deploy
```

---

## 🔐 Gateway Configuration

**`config/gateway.yml`**

```yaml
# Zayed Shield — Key Gateway Configuration

version: "3.0"

key_rotation:
  interval_seconds: 300       # 5 minutes (MINIMUM: 60)
  entropy_bits: 256
  algorithm: AES-512
  backup_count: 3             # keep last N expired keys

  # Rotation schedule override (optional)
  # schedule: "*/5 * * * *"  # cron syntax (overrides interval)

session:
  ttl_seconds: 3600           # session lifetime
  bind_to_ip: true            # invalidate session on IP change
  bind_to_ua: true            # invalidate on user-agent change
  concurrent_limit: 5         # max sessions per user

barcode:
  enabled: true
  format: CODE128             # CODE128 | QR | PDF417
  regenerate_on_rotation: true

secondary_key:
  enabled: true
  format: hex                 # hex | base64 | alphanumeric
  length: 32

storage:
  path: ./runtime/keys
  encryption: true
  permissions: "700"          # strict — owner only
```

---

## 🔬 Forensics Configuration

**`config/forensics.yml`**

```yaml
# Zayed Shield — Forensics Module Configuration

version: "3.0"

input:
  max_file_size_mb: 500
  allowed_extensions:
    - jpg
    - jpeg
    - png
    - gif
    - pdf
    - zip
    - exe
    - bin
    - pcap
    - log
  scan_archives: true         # extract and scan zip/tar contents
  archive_depth: 3            # max extraction depth

analysis:
  exif:
    enabled: true
    strip_on_export: false    # preserve original metadata
  steganography:
    enabled: true
    lsb_detection: true
    dct_detection: true
  hash_verification:
    enabled: true
    algorithms:
      - md5
      - sha1
      - sha256
      - sha512
  malware_scan:
    enabled: true
    engine: ai                # ai | signature | both
  chain_of_custody:
    enabled: true
    tamper_evident: true      # cryptographic sealing of evidence

output:
  path: ./archive/forensics
  format:
    - json                    # machine-readable
    - pdf                     # human-readable report
  encryption: true
  retention_days: 0           # 0 = permanent
```

---

## 📊 Monitor / Dashboard Configuration

**`config/monitor.yml`** (auto-generated — edit via dashboard UI)

```yaml
dashboard:
  port: 3000
  theme: dark                 # dark | light
  language: ar                # ar | en | both
  refresh_interval_ms: 1000

  widgets:
    - threat_feed
    - firewall_grid
    - ai_confidence_meter
    - key_rotation_timer
    - blocked_count
    - active_sessions
    - archive_stats

alerts:
  desktop_notifications: true
  sound_enabled: false
  critical_flash: true        # red border flash on critical alert
```

---

## 📝 Logging Configuration

**`config/logging.yml`**

```yaml
global:
  level: info                 # debug | info | warn | error
  format: json
  timestamp: iso8601

outputs:
  - type: file
    path: ./runtime/logs/app.log
    rotation:
      max_size_mb: 100
      max_files: 10
      compress: true
  - type: stdout
    colorize: true            # development only

modules:
  firewall:
    level: warn
    path: ./runtime/logs/firewall.log
  ai:
    level: info
    path: ./runtime/logs/ai.log
  gateway:
    level: info
    path: ./runtime/logs/gateway.log
  forensics:
    level: debug
    path: ./runtime/logs/forensics.log

# Audit log — NEVER disable in production
audit:
  enabled: true
  path: ./runtime/logs/audit.log
  append_only: true
  sign_entries: true          # GPG sign each batch
```

---

## 🔒 Security Hardening

Recommended production hardening checklist:

```bash
# 1. Restrict config file permissions
chmod 600 .env
chmod 600 config/*.yml
chmod 700 runtime/keys/

# 2. Run as non-root user
useradd -r -s /bin/false zayed-shield
chown -R zayed-shield:zayed-shield /opt/zayed-shield

# 3. Enable firewall on the host
ufw allow 3000/tcp             # dashboard only
ufw allow 443/tcp              # HTTPS if configured
ufw default deny incoming

# 4. Disable debug mode
sed -i 's/NODE_ENV=development/NODE_ENV=production/' .env
sed -i 's/LOG_LEVEL=debug/LOG_LEVEL=info/' .env

# 5. Rotate secrets on first deploy
node scripts/rotate-secrets.js

# 6. Verify all checksums
npm run verify:checksums
```

---

<div align="center">

[![Full Docs](https://img.shields.io/badge/Full-Documentation-009A44?style=for-the-badge&logo=readthedocs&logoColor=white)](https://github.com/nike4565/Zayed-Shield/tree/main/docs)
[![Open Issue](https://img.shields.io/badge/Need_Help%3F-Open_Issue-EF3340?style=for-the-badge&logo=github)](https://github.com/nike4565/Zayed-Shield/issues/new)

**🛡️ Zayed Shield Enterprise Security**

`CONFIGURATION GUIDE · درع زايد · UAE © 2025`

</div>

