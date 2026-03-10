#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

: "${PROD_SSH_HOST:?Missing PROD_SSH_HOST}"
: "${PROD_SSH_USER:?Missing PROD_SSH_USER}"
: "${GITHUB_SHA:?Missing GITHUB_SHA}"

TARGET_ENVIRONMENT="${TARGET_ENVIRONMENT:-production}"
DRY_RUN="${DRY_RUN:-false}"
PROD_APP_DIR="${PROD_APP_DIR:-/opt/zayed-shield}"

REMOTE_CMD=$(cat <<EOF
set -euo pipefail

APP_DIR="${PROD_APP_DIR}"

if [ ! -d "\$APP_DIR" ]; then
  mkdir -p "\$APP_DIR"
fi

cd "\$APP_DIR"

if [ ! -d ".git" ]; then
  echo "Repository not initialized in \$APP_DIR"
  exit 1
fi

git fetch --all --prune
git checkout main
git reset --hard "${GITHUB_SHA}"

if [ -f package.json ]; then
  if command -v npm >/dev/null 2>&1; then
    npm install --omit=dev || npm install
  fi
fi

if [ -f requirements.txt ]; then
  if command -v python3 >/dev/null 2>&1; then
    python3 -m pip install -r requirements.txt || true
  fi
fi

if [ -x "./scripts/post-deploy.sh" ]; then
  ./scripts/post-deploy.sh
fi

echo "Deployment completed on remote host"
EOF
)

log "Starting deployment"
log "Environment: ${TARGET_ENVIRONMENT}"
log "Target host: ${PROD_SSH_HOST}"
log "Application directory: ${PROD_APP_DIR}"
log "Commit: ${GITHUB_SHA}"
log "Dry run: ${DRY_RUN}"

if [ "${DRY_RUN}" = "true" ]; then
  log "Dry-run enabled. Remote command preview:"
  printf '%s\n' "${REMOTE_CMD}"
  exit 0
fi

ssh -o StrictHostKeyChecking=yes \
    "${PROD_SSH_USER}@${PROD_SSH_HOST}" \
    "${REMOTE_CMD}"

log "Deployment finished successfully"
