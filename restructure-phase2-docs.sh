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

move_path() {
  local src="$1"
  local dst_root="$2"

  [[ -e "$src" ]] || return 0
  ensure_dir "$dst_root"

  local rel="${src#docs/}"
  local dst="$dst_root/$rel"
  local parent
  parent="$(dirname "$dst")"

  ensure_dir "$parent"

  if [[ -e "$dst" ]]; then
    log "SKIP (exists): $src -> $dst"
    return 0
  fi

  do_cmd "mv \"$src\" \"$dst\""
}

log "========================================"
log " Docs Decontamination Phase 2"
log " Mode: $MODE"
log " Root: $(pwd)"
log "========================================"

DEST="archive/docs-contaminants"

# أنشئ مكان الأرشفة
ensure_dir "$DEST"

# انقل المجلدات غير التوثيقية كاملة
contaminated_dirs=(
  "docs/.devcontainer"
  "docs/.github"
  "docs/.sigstore"
  "docs/.zayed-core"
  "docs/defense"
  "docs/domain-analysis-20260310_080119"
  "docs/extras"
  "docs/firewall"
  "docs/proto"
  "docs/scripts"
  "docs/sentinel"
  "docs/src"
  "docs/tests"
  "docs/universal-security-remediation-engine"
  "docs/zayed-cybershield-protection"
)

for d in "${contaminated_dirs[@]}"; do
  move_path "$d" "$DEST"
done

# انقل الملفات غير التوثيقية من docs root
while IFS= read -r f; do
  base="$(basename "$f")"

  case "$base" in
    *.md) continue ;;
    public) continue ;;
    assets) continue ;;
  esac

  move_path "$f" "$DEST"
done < <(find docs -maxdepth 1 -type f | sort)

# انقل الملفات غير markdown داخل مستوى ثانٍ من docs
while IFS= read -r f; do
  case "$f" in
    docs/public/*|docs/assets/*) continue ;;
    *.md) continue ;;
  esac

  move_path "$f" "$DEST"
done < <(find docs -mindepth 2 -maxdepth 2 -type f | sort)

log
log "========================================"
log " Done."
log " Review:"
log "   find docs -maxdepth 2 -type f | sort | head -200"
log "   find archive/docs-contaminants -maxdepth 3 -type f | sort | head -200"
log "========================================"
