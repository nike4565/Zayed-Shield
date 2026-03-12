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

log "========================================"
log " Root Cleanup / Phase 3"
log " Mode: $MODE"
log " Root: $(pwd)"
log "========================================"

# -------------------------------------------------------------------
# 1) Target directories
# -------------------------------------------------------------------
for d in \
  archive/root-docs-duplicates \
  archive/manual-review \
  archive/analysis \
  archive/sentinel \
  archive/logs \
  archive/signatures
do
  ensure_dir "$d"
done

# -------------------------------------------------------------------
# 2) Move duplicated documentation from root
#    Only if same filename already exists under docs/
# -------------------------------------------------------------------
root_doc_dupes=(
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
  "SECURITY_VICTORY_REPORT.md"
  "THREAT-MODEL.md"
  "advanced_security.md"
  "pharaoh_merge_report_20260310_141918.md"
  "SECURITY_REPORT.md"
)

for f in "${root_doc_dupes[@]}"; do
  if [[ -f "$f" && -f "docs/$f" ]]; then
    move_file "$f" "archive/root-docs-duplicates"
  fi
done

# -------------------------------------------------------------------
# 3) Move weird/manual-review files from root
# -------------------------------------------------------------------
manual_review=(
  "ASRAR"
  "README"
  "Shield"
  "This"
  "Zayed-Shield"
  "e 🏆"
  "how 08fb529e7c47294e8367416321729f9b0da5cccd"
  "termux-shield.shxy"
)

for f in "${manual_review[@]}"; do
  move_file "$f" "archive/manual-review"
done

# -------------------------------------------------------------------
# 4) Move operational analysis / report directories from root
# -------------------------------------------------------------------
move_dir "domain-analysis-20260310_080119" "archive/analysis"
move_dir "sentinel" "archive/sentinel"
move_dir "logs" "archive/logs"

# -------------------------------------------------------------------
# 5) Move leftover .sig files outside archive/signatures
#    Conservative: only top-level and a few obvious subdirs
# -------------------------------------------------------------------
# root-level sigs
shopt -s nullglob
for f in ./*.sig; do
  move_file "${f#./}" "archive/signatures"
done
shopt -u nullglob

# specific subdirs to clean leftover signatures from
sig_dirs=(
  "defense"
  "extras"
  "firewall"
  "proto"
  "public"
  "scripts"
  "src"
  "tests"
  "zayed-cybershield-protection"
)

for d in "${sig_dirs[@]}"; do
  [[ -d "$d" ]] || continue
  while IFS= read -r f; do
    rel="${f#./}"
    base="$(basename "$rel")"
    if [[ -e "archive/signatures/$base" ]]; then
      log "SKIP (exists): $rel -> archive/signatures/$base"
      continue
    fi
    do_cmd "mv \"$rel\" \"archive/signatures/\""
  done < <(find "$d" -type f -name '*.sig' 2>/dev/null | sort)
done

log
log "========================================"
log " Done."
log " Review:"
log "   find . -maxdepth 1 -type f | sort"
log "   find archive/root-docs-duplicates -maxdepth 2 -type f | sort | head -200"
log "   find archive/manual-review -maxdepth 2 -type f | sort | head -200"
log "   find archive/signatures -maxdepth 2 -type f | sort | head -200"
log "========================================"
