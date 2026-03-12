#!/bin/bash

set -e

echo "🔧 Cleaning project structure..."

# إنشاء مجلدات مساعدة
mkdir -p archive/signatures
mkdir -p archive/manual-review
mkdir -p docs/security

# توحيد threat model
if [ -f docs/THREAT-MODEL.md ]; then
    mv docs/THREAT-MODEL.md docs/security/THREAT_MODEL.md
fi

if [ -f docs/THREAT_MODEL.md ]; then
    mv docs/THREAT_MODEL.md docs/security/THREAT_MODEL.md
fi

# نقل ملفات audit
if [ -f docs/ATTACK_SURFACE.md ]; then
    mv docs/ATTACK_SURFACE.md docs/security/
fi

if [ -f docs/SECURITY_AUDIT.md ]; then
    mv docs/SECURITY_AUDIT.md docs/security/
fi

# نقل ملفات غريبة من الجذر
for f in pharaohs_curse.sh sovereign.txt targets.json tunnel.js babelrc; do
    if [ -f "$f" ]; then
        mv "$f" archive/manual-review/
    fi
done

# نقل التوقيعات
find . -name "*.sig" -exec mv {} archive/signatures/ \; 2>/dev/null || true

# إنشاء .editorconfig
cat > .editorconfig <<EOF
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
EOF

# إنشاء Makefile بسيط
cat > Makefile <<EOF
install:
	npm install

test:
	npm test

start:
	node index.js
EOF

echo "📦 Adding changes to git..."

git add .

git commit -m "chore: clean repository structure, organize docs and signatures, add editorconfig and makefile" || true

git push origin main

echo "✅ Structure cleaned successfully."
