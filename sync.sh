#!/data/data/com.termux/files/usr/bin/bash

echo "==== Git Sync Start ===="

# الذهاب لمجلد المشروع
cd ~/Zayed-Shield/docs || exit

# سحب آخر تحديث من GitHub
echo "Pulling updates..."
git pull origin main

# إضافة التعديلات
echo "Adding changes..."
git add .

# عمل commit
msg="auto update $(date)"
git commit -m "$msg" 2>/dev/null

# رفع التحديثات
echo "Pushing to GitHub..."
git push origin main

echo "==== Sync Complete ===="
