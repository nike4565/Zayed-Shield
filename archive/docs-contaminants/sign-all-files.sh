#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

KEY_ID="CFC1FDE6BF547C9992EE40C3CFE4A9B2289E9650"

find . -type f \
  ! -path "./.git/*" \
  ! -path "./.gnupg/*" \
  ! -name "*.sig" \
  ! -name "private-key-backup.asc" \
  -print0 | while IFS= read -r -d '' file; do
    echo "Signing: $file"
    gpg --yes --local-user "$KEY_ID" --output "${file}.sig" --detach-sign "$file"
done

echo "✅ Done signing files"
