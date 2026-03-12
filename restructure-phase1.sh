#!/usr/bin/env bash
set -Eeuo pipefail

MODE="dry-run"
ROOT="${1:-.}"

if [[ "${1:-}" == "--apply" ]]; then
  MODE="apply"
  ROOT="${2:-.}"
elif [[ "${1:-}" == "--dry-run" ]]; then
  MODE="dry-run"
  ROOT="${2:-.}"
fi

cd "$ROOT"

log() {
  printf '%s\n' "$*"
}

do_cmd() {
  if [[ "$MODE" == "apply" ]]; then
    eval "$@"
  else
    printf '[DRY-RUN] %s\n' "$@"
  fi
}

ensure_dir() {
  local d="$1"
  do_cmd "mkdir -p \"$d\""
}

move_file() {
  local src="$1"
  local dst_dir="$2"

  [[ -e "$src" ]] || return 0
  ensure_dir "$dst_dir"

  local base
  base="$(basename "$src")"

  if [[ -e "$dst_dir/$base" ]]; then
    log "SKIP (exists): $src -> $dst_dir/$base"
    return 0
  fi

  do_cmd "mv \"$src\" \"$dst_dir/\""
}

move_dir() {
  local src="$1"
  local dst_dir="$2"

  [[ -d "$src" ]] || return 0
  ensure_dir "$dst_dir"

  local base
  base="$(basename "$src")"

  if [[ -e "$dst_dir/$base" ]]; then
    log "SKIP (exists): $src -> $dst_dir/$base"
    return 0
  fi

  do_cmd "mv \"$src\" \"$dst_dir/\""
}

log "========================================"
log " Zayed-Shield Restructure Phase 1"
log " Mode: $MODE"
log " Root: $(pwd)"
log "========================================"

for d in \
  docs \
  scripts/install \
  scripts/security \
  scripts/backup \
  scripts/release \
  scripts/ops \
  scripts/analysis \
  scripts/incident-response \
  archive/signatures \
  archive/backups \
  archive/workflow-assets \
  archive/logs \
  archive/recovery \
  archive/keys \
  runtime \
  bin \
  config
do
  ensure_dir "$d"
done

doc_files=(
  "BUSINESS_PLAN-ZayedCyberShield.md"
  "CODEOWNERS_GUIDE.md"
  "COMMUNITY.md"
  "COMPREHENSIVE-SECURITY-SHIELD.md"
  "CONTRIBUTORS.md"
  "CREDITS.md"
  "CUSTOMIZE.md"
  "CVE-2025-67847_Complete_Advisory.md"
  "CVE-REGISTRY.md"
  "DEPLOYMENT_GUIDE.md"
  "DOCUMENTATION.md"
  "EXECUTIVE_SUMMARY-ZayedShield.md"
  "GLOSSARY.md"
  "HEARTSHIELD.md"
  "INCIDENT-RESPONSE.md"
  "IP-DESIGN-PLAN-ZayedCyberShield.md"
  "MAGAZINE.md"
  "PATENTS-PLAN-ZayedCyberShield.md"
  "SCRAPY-CVE-ANALYSIS-AND-REMEDIATION.md"
  "SECURITY-FIX-LOG-v14.0.0.md"
  "SECURITY_CASES.md"
  "THREAT-MODEL.md"
  "advanced_security.md"
  "pharaoh_merge_report_20260310_141918.md"
  "SECURITY_REPORT.md"
  "SECURITY_VICTORY_REPORT.md"
)

for f in "${doc_files[@]}"; do
  move_file "$f" "docs"
done

config_files=(
  "config.yml"
  "domains-config.json"
  ".whitesource"
  "scheduled-installer-check.yml"
)

for f in "${config_files[@]}"; do
  move_file "$f" "config"
done

runtime_dirs=(
  ".aire"
  ".rtad"
  ".vih"
  ".zayed-core"
)

for d in "${runtime_dirs[@]}"; do
  move_dir "$d" "runtime"
done

archive_dirs=(
  ".backups"
  ".git-backup-before-unforking"
)

for d in "${archive_dirs[@]}"; do
  move_dir "$d" "archive/backups"
done

move_dir ".github/workflows-assets" "archive/workflow-assets"

sensitive_files=(
  "zayed-shield-gpg-private.asc"
  "zayed-shield-gpg.asc"
  "SIGSTORE.json"
  ".trigger"
)

for f in "${sensitive_files[@]}"; do
  move_file "$f" "archive/keys"
done

recovery_files=(
  "RELEASE-RECOVERY-NOTICE.md"
  "RELEASE-RECOVERY-SOURCE.md"
)

for f in "${recovery_files[@]}"; do
  move_file "$f" "archive/recovery"
done

bin_files=(
  "cloudflared"
  "mariadb-guardian"
  "nano"
  "zayed-shield"
)

for f in "${bin_files[@]}"; do
  move_file "$f" "bin"
done

backup_scripts=(
  "backup-system.sh"
  "break-fork-chain.sh"
  "safe_branch_cleaner.sh"
  "sync.sh"
  "update-repo.sh"
)

release_scripts=(
  "generate-provenance.sh"
  "git-merge-and-sign.sh"
  "push-to-new-repo.sh"
  "release_skyshield.sh"
  "sign-all-files.sh"
)

install_scripts=(
  "install.sh"
  "launcher.sh"
  "setup-language-theme.sh"
  "setup-zayed-cybershield.sh"
  "setup_codex_bot.sh"
  "setup_ops_room.sh"
  "cybershieldlauncher.sh"
)

incident_scripts=(
  "automated-incident-response-engine.sh"
  "critical-alert-automation-layer.sh"
  "real-time-alert-dispatcher.sh"
  "phase1_detection.sh"
  "phase2_monitoring.sh"
  "phase3_alerts.sh"
  "phase4_defense.sh"
)

analysis_scripts=(
  "domain-hunter.sh"
  "final-victory-verification.sh"
  "vulnerability-intelligence-hub.sh"
  "SECURITY-DATABASE-ENHANCEMENT-PROPOSAL.sh"
  "SCHEDULED-INSTALLER-CHECK-COMPLETE-GUIDE.sh"
)

security_scripts=(
  "GITHUB-SECURITY-REVOLUTION.sh"
  "ZAYED-CORE.sh"
  "asrar-shield.sh"
  "create_codeowners.sh"
  "gitignore-fortress.sh"
  "harden.sh"
  "network_guardian.sh"
  "nuclear_defense.sh"
  "repo-guard.sh"
  "security-fix.sh"
  "serve_zayed.sh"
  "validate_codeowners.sh"
)

ops_scripts=(
  "force-sync.sh"
  "start-tunnel.sh"
  "branch_protect.sh."
)

for f in "${backup_scripts[@]}"; do move_file "$f" "scripts/backup"; done
for f in "${release_scripts[@]}"; do move_file "$f" "scripts/release"; done
for f in "${install_scripts[@]}"; do move_file "$f" "scripts/install"; done
for f in "${incident_scripts[@]}"; do move_file "$f" "scripts/incident-response"; done
for f in "${analysis_scripts[@]}"; do move_file "$f" "scripts/analysis"; done
for f in "${security_scripts[@]}"; do move_file "$f" "scripts/security"; done
for f in "${ops_scripts[@]}"; do move_file "$f" "scripts/ops"; done

shopt -s nullglob
for f in ./*.sig; do
  move_file "${f#./}" "archive/signatures"
done
shopt -u nullglob

artifact_files=(
  "backup-system.sh.bak"
  "security-fix-report-20260310_074615.txt"
  "security-fix-report-20260310_135007.txt"
)

for f in "${artifact_files[@]}"; do
  move_file "$f" "archive/logs"
done

weird_files=(
  "ASRAR"
  "README"
  "Shield"
  "This"
  "e 🏆"
  "how 08fb529e7c47294e8367416321729f9b0da5cccd"
  "termux-shield.shxy"
  "advanced_security.py.sig"
  "zayed-shield.sig"
)

log
log "========================================"
log " Manual review recommended for these:"
for f in "${weird_files[@]}"; do
  [[ -e "$f" ]] && log " - $f"
done
log "========================================"

log
log "Done. Next steps:"
log "  1) Review: git status"
log "  2) If dry-run looked good, run:"
log "       ./restructure-phase1.sh --apply ."
log "  3) Then review again:"
log "       git status"
log "  4) Commit only after inspection."
